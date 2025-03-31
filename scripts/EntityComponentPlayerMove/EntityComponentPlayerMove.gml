function EntityComponentPlayerMove() : EntityComponentBase() constructor {
	// Variables
	self.dir = 1;
	self.current_hspd = 1.5;
	self.dash_jump = false;
	self.states = {
		walk: {
			speed: 1.5,	
		},
		dash: {
			speed: 3.5,	
			interval: 32
		},
		jump: {
			strength: 1363/256
		}
	}
	self.timer = 0;
	
	// Finite State Machine initialization
	self.fsm = new SnowState("init", false);
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
			enter: function() {	
				self.publish("on_jump", true);	
			},
			step: function() {
				self.set_hor_movement();
			},
			leave: function() {
				self.publish("on_jump", false);	
			}
		})
		.add_child("air", "jump", {
			enter: function() {
				self.fsm.inherit();
				self.publish("animation_play", { name: "jump" });
				self.physics.set_vspd(-self.states.jump.strength);	
			},
		})
		.add_child("air", "fall", {
			enter: function() {
				self.fsm.inherit();
				self.publish("animation_play", { name: "fall" });
				if (self.fsm.get_previous_state() == "jump")
					self.physics.set_vspd(0);
			}
		})
		.add("dash", {
			enter: function() {
				self.timer = 0;
				self.current_hspd = self.states.dash.speed;	
				self.dash_dir = self.dir;
				self.publish("animation_play", { name: "dash" });
			},
			step: function() {
				self.timer++;
				self.set_hor_movement(self.dash_dir);
			},
			leave: function() {
				self.dash_jump = self.input.get_input_pressed("jump");
				if (!self.dash_jump)
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
		.add_transition("t_init", "init", "idle")
		.add_transition("t_move_h", ["idle", "land"], "walk")
		.add_transition("t_dash", ["idle", "walk"], "dash")
		.add_transition("t_jump", ["idle", "walk", "dash"], "jump", function() { return self.physics.is_on_floor(); })
		.add_transition("t_crouch", "idle", "crouch")
		.add_transition("t_custom", ["idle", "air", "walk", "dash", "crouch"], "custom")
		.add_transition("t_custom_end", "custom", "idle")
		.add_transition("t_animation_end", ["start", "land", "dash_end"], "idle")
		.add_transition("t_transition", "walk", "idle", function() { return self.hdir == 0; })
		.add_transition("t_transition", "crouch", "idle", function() { return !self.input.get_input("down"); })
		.add_transition("t_transition", "jump", "fall", function() { return !self.input.get_input("jump"); })
		.add_transition("t_transition", "dash", "dash_end", function() { return self.hdir != self.dash_dir || self.timer >= self.states.dash.interval; })
		.add_transition("t_transition", "jump", "fall", function() { return self.physics.get_vspd() >= 0; })
		.add_transition("t_transition", "fall", "land", function() { return self.physics.is_on_floor(); })
		.add_transition("t_transition", "idle", "fall", function() { return !self.physics.is_on_floor(); })
		
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new EntityComponentInputBase();
			self.physics = self.parent.find("physics") ?? new EntityComponentPhysicsBase();
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
		self.dir = _dir;
		self.physics.set_hspd(self.current_hspd * _dir);
		if (_dir != 0) self.publish("animation_xscale", _dir)
	}
	
	// Double-tap detection system for activating dash
	self.double_tap = new MultiTap();
	self.double_tap.onPressed = function(_key, _times) {
		if (_times <= 1 || self.hdir != _key) return;
		self.double_tap.reset();
		self.dash_dir = _key;
		self.fsm.trigger("t_dash");
	}
	
	// Handles input and triggers attack transitions	
	self.step = function() {
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
		if (self.input.get_input("down")) self.fsm.trigger("t_crouch");
		self.fsm.trigger("t_transition");
		
		// Updates the FSM
		if (self.fsm.event_exists("step"))
			self.fsm.step();
	}
	
	self.draw_gui = function() {
		var _history = self.fsm.history_get();
		
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		draw_set_color(c_white);
		
		draw_text(16, 16, "Move FSM History");	
		for (var _i = 0, _len = array_length(_history); _i < _len; _i++) {
			draw_text(16, 16 + 16*(1 +_i), _history[_len - _i - 1]);	
		}
	}
}