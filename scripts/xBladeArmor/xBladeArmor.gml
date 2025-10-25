// For simplifying purposes, I am going to write all of these parts in the same script. 
function XBladeArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/blade/helm"//this is more for filepath.
}

function XBladeArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 0.5;
	self.sprite_name = "/blade/body"//this is more for filepath.
}

function XBladeArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.sprite_name = "/blade/arms"//this is more for filepath.
}

function XBladeArmorBoot() : BootPartBase() constructor{
	//increased dash speed
	self.sprite_name = "/blade/legs"//this is more for filepath.
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		_player.states.dash.speed *= 1.1;
		with(_player){
			struct_set(states, "mach_dash", {
				speed: 1298/256, //1298/256, 
				interval: 25, //25,
				max_dashes: 1, 
				curr_dashes: 0, 
				animation: "mach_dash", 
				angle: new Vec2(0,1), 
				only_cardinals: true, 
				golden: false,
				change_direction: false
			})
			
			if(keyboard_check(ord("P"))){
				self.states.mach_dash.only_cardinals = false;
				self.states.mach_dash.interval *= 1.25;
			}
			
			//falcon flight emulation
			if(keyboard_check(ord("N"))){
				self.states.mach_dash.change_direction = true;
				self.states.mach_dash.golden = true;
				self.states.mach_dash.only_cardinals = false;
				self.states.mach_dash.speed *= 0.75;
				self.states.mach_dash.interval *= 12.5;
			}
			
			self.get_instance().components.get(ComponentWeaponUse).shoot_inputs = ["shoot", "shoot2", "shoot3"]
			
			self.fsm.add("mach_dash", {
				enter: function() {//
					WORLD.play_sound("dash");
					if(!self.states.mach_dash.golden)
						self.states.mach_dash.curr_dashes++;
					var _inst = self.get_instance()
					
					self.current_hspd = self.states.mach_dash.speed;	
					self.physics.terminal_velocity = 1025;
					
					var _input_dir = new Vec2(self.hdir, self.vdir);
					if (_input_dir.x == 0 && _input_dir.y == 0) _input_dir = new Vec2(self.dir, 0);
					
					if(_input_dir.x == 0 && _input_dir.y == -1){
						self.publish("animation_play", { name: "mach_dash_up" });
						WORLD.spawn_particle(new DashUpParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
					} else if(_input_dir.x == 0 && _input_dir.y == 1){
						self.publish("animation_play", { name: "mach_dash_up" });
						self.publish("animation_yscale", -1);
						self.publish("animation_xscale", self.dir * -1);
						WORLD.spawn_particle(new DashDownParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
					} else {
						self.publish("animation_play", { name: "mach_dash" });
						self.dir = _input_dir.x;
						
						if(self.states.mach_dash.only_cardinals)
							var _input_dir = new Vec2(_input_dir.x, 0);
						
						self.publish("animation_xscale", self.dir)
						self.publish("animation_angle", 45 * (_input_dir.y * _input_dir.x))
						WORLD.spawn_particle(new DashParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
					}
					
					_input_dir = _input_dir.normalize();
					
					_input_dir.setY(_input_dir.y * 1.5)
					
					var _timer_mult = 1 / _input_dir.length();
					
					self.timer = CURRENT_FRAME + self.states.mach_dash.interval * _timer_mult;
					
					self.states.mach_dash.angle = _input_dir;
						
					self.physics.set_speed(self.states.mach_dash.angle.x * self.states.mach_dash.speed, self.states.mach_dash.angle.y * self.states.mach_dash.speed);
				},
				step: function() {
					if(!self.states.mach_dash.change_direction) return;
					var _input_dir = new Vec2(self.hdir, self.vdir);
					_input_dir = _input_dir.normalize();
					
					if(_input_dir.x == 0 && _input_dir.y == -1){
						self.publish("animation_play", { name: "mach_dash_up" });
						self.publish("animation_yscale", 1);
					} else if(_input_dir.x == 0 && _input_dir.y == 1){
						self.publish("animation_play", { name: "mach_dash_up" });
						self.publish("animation_yscale", -1);
					} else {
						self.publish("animation_play", { name: "mach_dash" });
						if(_input_dir.x != 0)
							self.dir = floor(_input_dir.x + 0.5);
						
						if(self.states.mach_dash.only_cardinals)
							var _input_dir = new Vec2(_input_dir.x, 0);
						
						self.publish("animation_xscale", self.dir)
						self.publish("animation_angle", 45 * (_input_dir.y * _input_dir.x))
						self.publish("animation_yscale", 1);
					}
					
					self.states.mach_dash.angle = _input_dir;
					
					self.physics.set_speed(self.states.mach_dash.angle.x * self.states.mach_dash.speed, self.states.mach_dash.angle.y * self.states.mach_dash.speed);
					
				},
				leave: function() {
					self.physics.set_grav(new Vec2(0,0.25));
					self.physics.set_speed(0,0);
					self.physics.terminal_velocity = self.physics.terminal_velocity_default;
					self.publish("animation_yscale", 1);
					self.publish("animation_angle", 0);
					self.publish("animation_xscale", self.dir);
				},
				draw: function(){
					var _anim = self.get_instance().components.find("animation");
					var _pos = _anim.get_interpolated_position();
					_pos[0] += self.physics.get_hspd() * (CURRENT_FRAME - self.timer) / 6;
					_pos[1] += self.physics.get_vspd() * (CURRENT_FRAME - self.timer) / 6;
					_anim.animation.set_color(c_blue);
					_anim.draw_regular(_pos);
					_anim.animation.set_color(c_white);
				}
			})
			.add("dash_hold", {
				enter: function() {
					self.publish("animation_play", { name: "mach_hold" });
					self.physics.set_speed(0,0);
					self.physics.set_grav(new Vec2(0,0));
				},
				step: function() {
					if(self.input.get_input_released("dash") || self.input.get_input_released("shoot4"))
						self.fsm.change("mach_dash");
					if(self.input.get_input_pressed_raw("left")){
						self.publish("animation_xscale", -1);
						self.dir = -1;
					}
					if(self.input.get_input_pressed_raw("right")){
						self.publish("animation_xscale", 1);
						self.dir = 1;
					}
				},
				leave: function() {
				},
				draw: function(){
					var _inst = self.get_instance();
					var _dir = new Vec2(self.hdir, self.vdir);
					if (_dir.x == 0 && _dir.y == 0) _dir = new Vec2(self.dir, 0);
					_dir = _dir.normalize();
					
					draw_set_color(c_black)
					draw_arrow(_inst.x + (_dir.x * 32), _inst.y + (_dir.y * 32), _inst.x + (_dir.x * 40), _inst.y + (_dir.y * 40), 15)
					draw_set_color(c_white)
					draw_arrow(_inst.x + (_dir.x * 30), _inst.y + (_dir.y * 30), _inst.x + (_dir.x * 38), _inst.y + (_dir.y * 38), 8)
				}
			})
			.add_wildcard_transition("t_dash", "dash_hold", function() { return !self.physics.check_wall(self.dash_dir) && !self.physics.is_on_floor() && self.states.mach_dash.curr_dashes < self.states.mach_dash.max_dashes; })
			.add_transition("t_transition", "mach_dash", "fall", function() 
				{ return self.timer <= CURRENT_FRAME; })
			.add_wildcard_transition("t_transition", "dash_hold", function() {return self.input.get_input_pressed_raw("shoot4") && self.states.mach_dash.curr_dashes < self.states.mach_dash.max_dashes;});
		}
		
		self.step_armor_effects = function(_player) {
			if(_player.physics.is_on_floor() || _player.fsm.get_current_state() == "wall_slide")
				_player.states.mach_dash.curr_dashes = 0;
		};
	}
}