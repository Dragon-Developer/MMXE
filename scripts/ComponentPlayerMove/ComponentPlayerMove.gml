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
	self.paused = false;
	self.can_wall_jump = true;
	self.states = {
		walk: {
			speed: 376/256,	
			animation: "walk_smooth"
		},
		dash: {
			speed: 885/256,	
			interval: 32,
			animation: "dash"
		},
		jump: {
			strength: 1363/256,
			animation: "jump_smooth"
		},
		fall:{
			animation: "fall_smooth"
		},
		wall_jump: {
			strength: 5
		},
		ladder: {
			speed: 376/256
			//496/256 if its with arm parts
		},
		hurt: {
			speed: -138 / 256
		}
	}
	self.timer = 0;
	
	self.armor_parts = [
		new XFirstArmorHead(), 
		new XFirstArmorBody(), 
		new XFirstArmorArms(), 
		new XFirstArmorBoot()];// Head, Body, Arms, Boot
	
	self.serializer
		.addVariable("dir")
		.addVariable("timer")
		.addVariable("current_hspd")
		.addVariable("dash_dir")
		.addVariable("dash_jump")
		.addVariable("dash_tapped")
		.addVariable("armor_parts")
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
				//self.publish("animation_play", { name: "walk" });
				self.publish("animation_play", { name: self.states.walk.animation });
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
				self.input.__useBuffer = false;
				self.fsm.inherit();
				//self.publish("animation_play", { name: "jump" });
				self.publish("animation_play", { name: self.states.jump.animation });
				self.physics.set_vspd(-self.states.jump.strength);
				if (self.fsm.get_previous_state() == "dash" || self.input.get_input("dash"))
					self.current_hspd = self.states.dash.speed;
			},
		})
		.add_child("air", "fall", {
			enter: function() {
				self.fsm.inherit();
				//self.publish("animation_play", { name: "fall" });
				self.publish("animation_play", { name: self.states.fall.animation });
				if (self.fsm.get_previous_state() == "jump")
					self.physics.set_vspd(0);
				if(self.physics.get_vspd() < 0)
					self.physics.set_vspd(0);
			}
		})
		.add("dash", {
			enter: function() {//
				self.timer = CURRENT_FRAME + self.states.dash.interval;
				self.current_hspd = self.states.dash.speed;	
				self.dash_dir = self.dir;
				if(self.dash_dir == 0)
					self.dash_dir = self.hdir;
				self.publish("animation_play", { name: self.states.dash.animation });
			},
			step: function() {
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
				self.input.__useBuffer = true;
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
				self.input.__useBuffer = true;
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
				self.input.__useBuffer = false;
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
					self.input.__useBuffer = true;
					self.publish("animation_play", { name: "jump", frame: 10, reset: false});
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
		.add("ladder", {
			enter: function() {
				self.physics.set_speed(0, 0);
				self.physics.set_grav(0);
				self.get_instance().components.get(ComponentAnimation).animation.__speed = 0;
				//self.publish("animation_play", { name: "ladder" });
			},
			leave: function(){
				self.physics.update_gravity();
				self.physics.set_vspd(0);
				self.get_instance().components.get(ComponentAnimation).animation.__speed = 1;
			}
		})
		.add_child("ladder", "ladder_enter", {
			enter: function(){
				self.fsm.inherit();
				with(self.get_instance()){
					x = instance_nearest(x,y,obj_ladder).x + 16;
				}
				self.publish("animation_play", { name: "ladder_enter" });
				self.fsm.change("ladder")
			}
		})
		.add_child("ladder", "ladder_move", {
			enter: function(){
				self.fsm.inherit();
				self.publish("animation_play", { name: "ladder_move" });
				self.get_instance().components.get(ComponentAnimation).animation.__speed = 1;
			},
			step: function(){
				self.get_instance().y += self.vdir * self.states.ladder.speed;
			}
		})
		.add("ladder_exit", {
			enter: function(){
				self.get_instance().components.get(ComponentAnimation).animation.__speed = 1;
				self.publish("animation_play", { name: "ladder_exit" });
				self.fsm.change("fall")
			},
			leave: function(){
				self.physics.update_gravity();
				self.physics.set_vspd(0);
			}
		})
		.add("hurt", {
			enter: function(){
				self.physics.velocity = new Vec2(self.dir * self.states.hurt.speed,2);
			},
			step: function(){
				
			},
			leave: function(){
				
			}
		})
		.add_transition("t_init", "init", "idle")
		.add_transition("t_move_h", ["idle", "land"], "walk", function() { return !self.physics.check_wall(self.hdir); })
		.add_wildcard_transition("t_dash", "dash", function() { return !self.physics.check_wall(self.dash_dir) && self.physics.is_on_floor(); })
		.add_wildcard_transition("t_hurt", "hurt", function() { return !self.fsm.get_current_state() == "wall_slide" })
		.add_transition("t_jump", ["idle", "walk", "dash", "land", "dash_end", "crouch"], "jump", function() { return self.physics.is_on_floor() && !self.physics.is_on_ceil(6); })
		.add_transition("t_crouch", "idle", "crouch")
		.add_wildcard_transition("t_custom", "custom")
		.add_transition("t_custom_end", "custom", "idle")
		//.add_transition("t_custom", ["air", "walk"], "custom")  why does this line exist when the above line covers it
		.add_transition("t_custom_exit", "custom", "jump")
		.add_transition("t_animation_end", ["start", "land", "dash_end"], "idle")
		.add_transition("t_animation_end", "ladder_exit", "idle")
		.add_transition("t_dash_end", "dash", "fall", function() { return !self.physics.is_on_floor(); })
		.add_transition("t_dash_end", "dash", "dash_end", function() { return self.physics.is_on_floor(); })
		.add_transition("t_jump", "wall_slide", "wall_jump")
		.add_transition("t_jump", ["ladder", "ladder_move"], "jump")
		.add_transition("t_jump", ["air"], "wall_jump", function() { return self.get_wall_jump_dir() != 0; })
		.add_wildcard_transition("t_jump", "wall_jump", function() { return self.get_wall_jump_dir() != 0; })
		.add_wildcard_transition("t_dialouge", "idle")
		/*automatic transitions between states*/
		.add_transition("t_transition", "walk", "idle", function() { return self.hdir == 0 || self.physics.check_wall(self.hdir); })
		.add_transition("t_transition", "crouch", "idle", function() { return !self.input.get_input("down"); })
		.add_transition("t_transition", "jump", "fall", function() { return !self.input.get_input("jump") || self.physics.is_on_ceil(); })
		.add_transition("t_transition", "wall_jump", "fall", function() { return (!self.input.get_input("jump") || self.physics.is_on_ceil()) && self.timer > 10 || self.physics.get_vspd() > 0; })
		.add_transition("t_transition", "wall_slide", "fall", function() { return self.hdir != self.dir || !self.wall_slide_possible(); })
		.add_transition("t_transition", ["fall", "idle", "walk", "dash", "walljump"], "ladder_enter", function() { return self.vdir != 0 && self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_ladder)})
		.add_transition("t_transition", "ladder", "ladder_move", function() { return self.vdir != 0})
		.add_transition("t_transition", "ladder_move", "ladder", function() { return self.vdir == 0})
		.add_transition("t_transition", "ladder_move", "ladder", function() { return self.vdir == 0})
		.add_transition("t_transition", ["ladder", "ladder_move"], "ladder_exit", function() { 
			return !self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_ladder) || self.physics.is_on_floor()
		})
		.add_transition("t_transition", "dash", "dash_end", function() 
		{ return (self.hdir != self.dash_dir && (self.hdir != 0 || self.dash_tapped)) || self.timer <= CURRENT_FRAME || (!self.dash_tapped && !self.input.get_input("dash")); })
		.add_transition("t_transition", "jump", "fall", function() { return self.physics.get_vspd() >= 0; })
		.add_transition("t_transition", ["fall", "wall_slide"], "land", function() { return self.physics.is_on_floor(); })
		.add_transition("t_transition", ["idle", "walk", "crouch"], "fall", function() { return !self.physics.is_on_floor(); })
		.add_transition("t_transition", "fall", "wall_slide", function(){ return self.wall_slide_possible();})
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
		self.subscribe("player_set_armor_full", function(_armors) {
			self.apply_full_armor_set(_armors);
		});
		self.subscribe("player_set_armor_part", function(_armors) {
			self.apply_full_armor_set(_armors);
		});
		self.subscribe("took_damage", function() {
			self.fsm.trigger("t_hurt")
		});
	}
	
	// Initialization
	self.init = function() {
		self.fsm.trigger("t_init");
		//self.apply_full_armor_set(self.armor_parts);
		
		/*
		
			loading armor data from json files? 
			
			maybe. it would make sense, but i think json has some extreme limitations
		
		*/
		
	}
	
	self.apply_full_armor_set = function(_armors){
		self.armor_parts = [];
		//var _armors_to_load = [];
		array_foreach(_armors, function(_arm){
			array_push(self.armor_parts, _arm)
			if(_arm != noone){
				self.get_instance().components.get(ComponentAnimation).add_subdirectories(["/" + string(_arm.sprite_name)]);
				if(variable_struct_exists(_arm, "apply_armor_effects"))
					_arm.apply_armor_effects(self);
				else
					log("this thing doesnt have an armor effect variable!")
			}
		});
	}
	self.apply_armor_part = function(_armor){
		if(_armor == BootPartBase){
			
		} else if(_armor == ArmsPartBase){
			
		} else if(_armor == BodyPartBase){
			
		} else if(_armor == HeadPartBase){
			
		} else {
			log("whatever you passed in here, it sure wasnt an armor struct!")
		}
	}
	
	self.remove_armor_part = function(){
		
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
		if(!paused && !locked)
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