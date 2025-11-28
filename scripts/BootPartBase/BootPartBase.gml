function BootPartBase() : ArmorBase() constructor{
	self.can_air_dash = false;
	self.dash_length_addition = 0;
	self.air_dash_length_addition = 0;
	
	self.add_air_dash = function(_player){
		with(_player){
			struct_set(states, "dash_air", {speed: self.states.dash.speed, interval: 15, max_dashes: 1, curr_dashes: 0, animation: "dash_air"})
			
			self.fsm.add("dash_air", {
				enter: function() {//
					WORLD.play_sound("dash");
					self.states.dash_air.curr_dashes++;
					var _inst = self.get_instance()
					WORLD.spawn_particle(new DashParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
					self.timer = CURRENT_FRAME + self.states.dash_air.interval;
					self.current_hspd = self.states.dash.speed;	
					self.dash_dir = self.dir;
					if(self.dash_dir == 0)
						self.dash_dir = self.hdir;
					self.publish("animation_play", { name: self.states.dash_air.animation });
					self.physics.set_speed(0, 0);
					self.physics.set_grav(new Vec2(0,0));
				},
				step: function() {
					self.set_hor_movement(self.dash_dir);
				},
				leave: function() {
					//if (!self.dash_jump && self.physics.is_on_floor())
						//self.current_hspd = self.states.walk.speed;	
					self.physics.set_grav(new Vec2(0,0.25));
				}
			})
			
		.add("dash_end_air", {
			enter: function() {
				self.timer = 0;
				self.dash_dir = self.dir;
				self.publish("animation_play", { name: self.states.dash.animation + "_end" });
				self.dash_tapped = false;
			},
			step: function() {
				self.set_hor_movement();
			},
		})
			.add_wildcard_transition("t_dash", "dash_air", function() { return !self.physics.check_wall(self.dash_dir) && !self.physics.is_on_floor() && self.states.dash_air.curr_dashes < self.states.dash_air.max_dashes; })
			.add_transition("t_dash_end", "dash_air", "dash_end_air", function() { return self.physics.is_on_floor(); })
			.add_transition("t_transition", "dash_air", "dash_end_air", function() 
				{ return (self.hdir != self.dash_dir && (self.hdir != 0 || self.dash_tapped)) || self.timer <= CURRENT_FRAME || (!self.dash_tapped && !self.input.get_input("dash")); })
			.add_transition("t_animation_end", "dash_end_air", "fall")
		}
		self.step_armor_effects = function(_player) {
			if(_player.physics.is_on_floor() || _player.fsm.get_current_state() == "wall_slide")
				_player.states.dash_air.curr_dashes = 0;
		};
	}
	
	self.add_slide = function(_player){
		with(_player){
			struct_set(states, "slide", {speed: self.states.dash.speed, interval: self.states.dash.interval, animation: "slide", old_hitbox: noone})
			log("GJNGIHIDUSBGHUBSDGHIBSUIBDSJHGBSHJGBDSGIBI SLIDE")
			self.fsm.add("slide", {
				enter: function() {//
					self.states.slide.old_hitbox = self.get_instance().mask_index;
					self.get_instance().mask_index = spr_slide_mask;
					//self.get_instance().y -= 4;
					log("pre")
					WORLD.play_sound("dash");
					var _inst = self.get_instance()
					WORLD.spawn_particle(new DashParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
					self.timer = CURRENT_FRAME + self.states.slide.interval;
					self.current_hspd = self.states.slide.speed;	
					self.dash_dir = self.dir;
					if(self.dash_dir == 0)
						self.dash_dir = self.hdir;
					self.publish("animation_play", { name: self.states.slide.animation });
				},
				step: function() {
					self.set_hor_movement(self.dash_dir);
				},
				leave: function() {
					//if (!self.dash_jump && self.physics.is_on_floor())
						//self.current_hspd = self.states.walk.speed;	
					self.physics.set_grav(new Vec2(0,0.25));
					self.get_instance().mask_index = self.states.slide.old_hitbox;
				}
			})
			.add("slide_end", {
				enter: function() {
					self.timer = 0;
					self.dash_dir = self.dir;
					self.publish("animation_play", { name: self.states.slide.animation + "_end" });
					self.dash_tapped = false;
				},
				step: function() {
					self.set_hor_movement();
				},
				leave: function(){
				}
			})
			.add_transition("t_transition", "slide", "slide_end", function() 
			{ 
				var _can_bail = true;
				if(self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y - 16, obj_square_16)){
					
					if(self.timer + 5 <= CURRENT_FRAME)
						self.timer++;
						
					_can_bail = false;
				}
				
				return _can_bail && ((self.hdir != self.dash_dir && (self.hdir != 0 || self.dash_tapped)) || self.timer <= CURRENT_FRAME || (!self.dash_tapped && !self.input.get_input("down"))); })
			.add_transition("t_dash_end", "slide", "fall", function() { return !self.physics.is_on_floor(); })
			.add_transition("t_dash_end", "slide", "slide_end", function() { return self.physics.is_on_floor(); })
			self.fsm.add_wildcard_transition("t_slide", "slide", function() { log("checking")
				return !self.physics.check_wall(self.dash_dir) && self.physics.is_on_floor(); })
			.add_transition("t_animation_end", "slide_end", "idle")
		}
		self.step_armor_effects = function(_player) {
			if (_player.input.get_input_pressed_raw("jump") && _player.input.get_input("down") && !_player.physics.check_wall(_player.dash_dir) && _player.physics.is_on_floor()) { 
				_player.fsm.change("slide"); 
				log("yoom")
			}
		};
	}
}