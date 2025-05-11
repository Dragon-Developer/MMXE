function ComponentPlayerMove() : ComponentBase() constructor {
	self.add_tags("player");
	// Variables
	self.dir = 1;
	self.dash_dir = 1;
	self.current_hspd = 1.5;
	self.dash_jump = false;
	self.dash_tapped = false;
	self.debug = global.debug;
	self.camera = noone;
	self.locked = false;
	self.ride_armor = noone;
	self.can_wall_jump = true;
	self.states = {
		walk: {
			speed: 1.75,	
		},
		dash: {
			speed: 3.5,	
			interval: 32
		},
		jump: {
			strength: 1363/256
		},
		wall_jump: {
			strength: 5
		}
	}
	self.timer = 0;
	self.serializer
		.addVariable("dir")
		.addVariable("timer")
		.addVariable("current_hspd")
		.addVariable("dash_dir")
		.addVariable("dash_jump")
		.addVariable("dash_tapped")
		.addCustom("double_tap")
		.addCustom("fsm");
	
	// Finite State Machine initialization
	self.fsm = new SnowState("init", false);
	#region fsm
	self.fsm
		.history_enable()
		.history_set_max_size(10)
		.add("init", {})
		.add("start", {
			enter: function() {
				self.publish("animation_play", { name: "intro" });
			},
		})
		.add("idle", {
			enter: function() {
				self.publish("animation_play", { name: "idle" });
				self.physics.set_speed(0, 0);
			},
		})
		.add("walk", {
			enter: function() {
				self.publish("animation_play", { name: "walk" });
				self.current_hspd = self.states.walk.speed;
			},
			step: function() {
				self.set_hor_movement();	
			}
		})
		.add("air", {
			step: function() {
				self.set_hor_movement();
			}
		})
		.add_child("air", "jump", {
			enter: function() {
				self.fsm.inherit();
				self.publish("animation_play", { name: "jump" });
				self.physics.set_vspd(-self.states.jump.strength);
				if (self.fsm.get_previous_state() == "dash" || self.input.get_input("dash"))
					self.current_hspd = self.states.dash.speed;
			},
		})
		.add_child("air", "fall", {
			enter: function() {
				self.fsm.inherit();
				self.publish("animation_play", { name: "fall" });
				if (self.fsm.get_previous_state() == "jump")
					self.physics.set_vspd(0);
				if(self.physics.get_vspd() < 0)
					self.physics.set_vspd(0);
			}
		})
		.add("dash", {
			enter: function() {
				self.timer = 0;
				self.current_hspd = self.states.dash.speed;	
				self.dash_dir = self.dir;
				if(self.dash_dir == 0)
					self.dash_dir = self.hdir;
				self.publish("animation_play", { name: "dash" });
			},
			step: function() {
				self.timer++;
				self.set_hor_movement(self.dash_dir);
			},
			leave: function() {
				self.dash_jump = self.input.get_input_pressed("jump");
				if (!self.dash_jump && self.physics.is_on_floor())
					self.current_hspd = self.states.walk.speed;	
			}
		})
		.add("dash_end", {
			enter: function() {
				self.timer = 0;
				if (!self.dash_jump)
					self.current_hspd = self.states.walk.speed;	
				self.dash_dir = self.dir;
				self.publish("animation_play", { name: "dash_end" });
				self.dash_tapped = false;
			},
			step: function() {
				self.set_hor_movement();
			},
		})
		.add("land", {
			enter: function() {
				self.publish("animation_play", { name: "land" });
			},
			leave: function() {
				self.dash_jump = false;	
			}
		})
		.add("custom", {})
		.add("crouch", {
			enter: function() {
				self.publish("animation_play", { name: "crouch" });
				self.physics.set_speed(0, 0);
				self.publish("on_crouch", false);	
			},
			leave: function() {
				self.publish("on_crouch", false);		
			}
		})
		.add("wall_slide", {
			enter: function() {
				self.timer = 0;
				self.publish("animation_play", { name: "wall_slide" });
				self.physics.set_speed(0, 0);
				self.physics.set_grav(0);
				self.dash_jump = false;
				self.current_hspd = self.states.walk.speed;	
			},
			leave: function() {	
				self.physics.update_gravity();
				self.physics.set_vspd(0);
			},
			step: function() {
				self.timer++;
				if(self.timer == 6){
					self.physics.set_vspd(2);
				}
				self.set_hor_movement();	
			}
		})
		.add("wall_jump", {
			enter: function() {
				self.timer = 0;
				self.publish("animation_play", { name: "wall_jump" });
				self.dir = self.get_wall_jump_dir();
				if (self.dir != 0) self.publish("animation_xscale", self.dir)
				self.physics.set_speed(0, 0);
				self.physics.set_grav(0);
			},
			leave: function() {	
				self.physics.update_gravity();
			},
			step: function() {
				self.timer++;
				if (self.timer > 11){
					self.publish("animation_play_at_loop", { name: "jump", frame: 10});
					self.set_hor_movement();
				} else if (self.timer > 7) {
					//please this looks so much better
					//self.publish("animation_play_at_loop", { name: "jump", frame: 10});
				}
				if (self.timer == 5) {
					self.physics.update_gravity();
					if (self.input.get_input("dash")) {
						self.current_hspd = self.states.dash.speed;	
						if (!self.physics.is_on_ceil() || self.dir != self.hdir)
							self.physics.set_hspd(self.states.dash.speed * self.dir * -1)
						self.dash_jump = true;
					} else {
						if (!self.physics.is_on_ceil() || self.dir != self.hdir)
							self.physics.set_hspd(self.states.walk.speed * self.dir * -1)
					}
					self.physics.set_vspd(-self.states.wall_jump.strength);	
				}
			}
		})
		.add("ride", {
			enter: function() {
				self.publish("animation_play", { name: "crouch" });
				self.physics.set_speed(0, 0);
				self.physics.set_grav(0);
			},
			step: function(){
				if(self.ride_armor != noone){
					var _inst = self.get_instance();
					_inst.x = self.ride_armor.x;
					_inst.y = self.ride_armor.y - 12;
				}
			},
			leave: function(){
				self.physics.update_gravity();
				self.physics.set_vspd(0);
			}
		})
		.add_transition("t_init", "init", "idle")
		.add_transition("t_move_h", ["idle", "land"], "walk", function() { return !self.physics.check_wall(self.hdir); })
		.add_wildcard_transition("t_dash", "dash", function() { return !self.physics.check_wall(self.dash_dir) && self.physics.is_on_floor(); })
		.add_transition("t_jump", ["idle", "walk", "dash", "land", "dash_end", "crouch"], "jump", function() { return self.physics.is_on_floor(); })
		.add_transition("t_crouch", "idle", "crouch")
		.add_transition("t_custom", ["idle", "air", "walk", "dash", "crouch"], "custom")
		.add_transition("t_custom_end", "custom", "idle")
		.add_transition("t_custom", ["air", "walk"], "custom")
		.add_transition("t_custom_exit", "custom", "jump")
		.add_transition("t_animation_end", ["start", "land", "dash_end"], "idle")
		.add_transition("t_dash_end", "dash", "fall", function() { return !self.physics.is_on_floor(); })
		.add_transition("t_dash_end", "dash", "dash_end", function() { return self.physics.is_on_floor(); })
		/*automatic transitions between states*/
		.add_transition("t_transition", "walk", "idle", function() { return self.hdir == 0 || self.physics.check_wall(self.hdir); })
		.add_transition("t_transition", "crouch", "idle", function() { return !self.input.get_input("down"); })
		.add_transition("t_transition", "jump", "fall", function() { return !self.input.get_input("jump") || self.physics.is_on_ceil(); })
		.add_transition("t_transition", "wall_jump", "fall", function() { return (!self.input.get_input("jump") || self.physics.is_on_ceil()) && self.timer > 10 || self.physics.get_vspd() > 0; })
		.add_transition("t_transition", "wall_slide", "fall", function() { return self.hdir != self.dir || !self.wall_slide_possible(); })
		.add_transition("t_jump", "wall_slide", "wall_jump")
		.add_transition("t_jump", ["air"], "wall_jump", function() { return self.get_wall_jump_dir() != 0; })
		.add_wildcard_transition("t_jump", "wall_jump", function() { return self.get_wall_jump_dir() != 0; })
		.add_transition("t_transition", "dash", "dash_end", function() 
		{ return (self.hdir != self.dash_dir && (self.hdir != 0 || self.dash_tapped)) || self.timer >= self.states.dash.interval || (!self.dash_tapped && !self.input.get_input("dash")); })
		.add_transition("t_transition", "jump", "fall", function() { return self.physics.get_vspd() >= 0; })
		.add_transition("t_transition", ["fall", "wall_slide"], "land", function() { return self.physics.is_on_floor(); })
		.add_transition("t_transition", ["idle", "walk", "crouch"], "fall", function() { return !self.physics.is_on_floor(); })
		.add_transition("t_transition", "fall", "wall_slide", function()
		{ return self.wall_slide_possible();})
	#endregion
	
	self.wall_slide_possible = function(){
		return self.hdir != 0 && self.physics.check_wall(self.hdir);
	}
	
	self.get_wall_jump_dir = function() {
		if (self.physics.is_on_floor()) return 0;
		if (self.physics.check_wall(9)) return 1;
		if (self.physics.check_wall(-9)) return -1;
		return 0;
	}
		
		
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
			//What the heck is the parent of this? is it the player object?
			self.weaponHandler = self.parent.find("weaponHandler") ?? new ComponentWeaponUse();
		});
		self.subscribe("animation_end", function() {
			self.fsm.trigger("t_animation_end");	
		});
	}
	// Initialization
	self.init = function() {
		self.fsm.trigger("t_init");

	}
	
	// Sets the player's horizontal movement based on direction
	self.set_hor_movement = function(_dir = self.hdir) {
		if (_dir != 0) self.dir = _dir;
		self.physics.set_hspd(self.current_hspd * _dir);
		if (_dir != 0) self.publish("animation_xscale", _dir)
	}
	
	// Double-tap detection system for activating dash
	self.double_tap = new MultiTap();
	self.double_tap.onPressed = function(_key, _times) {
		if (_times <= 1 || self.dir != _key) return;
		self.double_tap.reset();
		self.dash_dir = _key;
		self.dash_tapped = true;
		self.fsm.trigger("t_dash");
	}
	
	// Handles input and triggers attack transitions	
	self.step = function() {
		self.default_step();
	}
	
	self.default_step = function(){
	// Gets horizontal and vertical directions from player input
		self.hdir = self.input.get_input("right") - self.input.get_input("left");
		self.vdir = self.input.get_input("down") - self.input.get_input("up");
		
		// Detects double-tap input to activate dash
		if (self.input.get_input_pressed("right")) self.double_tap.pressed(1);
		if (self.input.get_input_pressed("left")) self.double_tap.pressed(-1);
		self.double_tap.step();
		
		// Trigger FSM transitions
		if (self.hdir != 0) self.fsm.trigger("t_move_h");
		if (self.vdir != 0) self.fsm.trigger("t_move_v");
		if (self.input.get_input_pressed("jump")) self.fsm.trigger("t_jump");
		if (self.input.get_input_pressed("dash") && !self.input.get_input_pressed("jump")) { 
			self.fsm.trigger("t_dash"); 
			self.dash_tapped = false;
		}
		if (self.input.get_input("down")) self.fsm.trigger("t_crouch");
		
		if (!self.physics.is_on_floor()) fsm.trigger("t_dash_end");
		if (self.physics.check_wall(self.dash_dir)) fsm.trigger("t_dash_end");
		self.fsm.trigger("t_transition");
		
		// Updates the FSM
		if (self.fsm.event_exists("step"))
			self.fsm.step();	
	}
	
	self.draw_gui = function() {
		
		if !self.debug return;
		var _history = self.fsm.history_get();
		
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		draw_set_color(c_white);
		
		draw_text(16, 0, string(self.dash_dir) + ", " + string(self.dir));	
		draw_text(16, 16, "Move FSM History");	
		for (var _i = 0, _len = array_length(_history); _i < _len; _i++) {
			draw_text(16, 16 + 16*(1 +_i), _history[_len - _i - 1]);	
		}
	}
}