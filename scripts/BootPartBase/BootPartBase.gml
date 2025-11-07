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
}