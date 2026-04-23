function add_dash(_entity = undefined){
	with(_entity){
		self.fsm.add("dash", {
			enter: function() {//
				WORLD.play_sound(self.states.dash.sound);
				var _inst = self.get_instance();
					WORLD.spawn_particle(new DashParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
				self.timer = CURRENT_FRAME + self.states.dash.interval;
				self.dash_dir = self.dir;
				if(self.dash_dir == 0)
					self.dash_dir = self.hdir;
				self.publish("animation_play", { name: self.states.dash.animation });
				
				//extra jargon
				if(variable_struct_exists(self.states, "melee"))
					self.states.melee.animation = "undefined"
					
				//self.get_instance().y = floor(self.get_instance().y)
			},
			step: function() {
				self.set_hor_movement(self.dash_dir);
				if(CURRENT_FRAME >= self.timer - self.states.dash.interval + 2)
					self.current_hspd = self.states.dash.speed;	
				if(CURRENT_FRAME mod 4 == 0){
					var _inst = self.get_instance();
					WORLD.spawn_particle(new DustParticle(_inst.x- 16 * self.dir, _inst.y + 8, self.dir))
				}
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
				self.publish("animation_play", { name: self.states.dash.animation + "_end" });
				self.dash_tapped = false;
			},
			step: function() {
				self.set_hor_movement();
			},
		})
		.add_transition("t_transition", "dash", "dash_end", function() 
		{ return (self.hdir != self.dash_dir && (self.hdir != 0 || self.dash_tapped)) || self.timer <= CURRENT_FRAME || (!self.dash_tapped && !self.input.get_input("dash")); })
		.add_transition("t_transition", ["land"], "dash", function() { return self.input.get_input("dash") && global.settings.Dash_On_Land })
		.add_transition("t_dash_end", "dash", "fall", function() { return !self.physics.is_on_floor(self.ground_distance + 1); })
		.add_transition("t_dash_end", "dash", "dash_end", function() { return self.physics.is_on_floor(self.ground_distance + 1); })
		.add_wildcard_transition("t_dash", "dash", function() { return !self.physics.check_wall(self.dash_dir) && self.physics.is_on_floor(self.ground_distance) && !self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_square_16); })
	}
}
	
function add_wall_jump(_entity = undefined){
	with(_entity){
		self.fsm.add("wall_slide", {
			enter: function() {
				self.input.__useBuffer = true;
				self.timer = 0;
				self.publish("animation_play", { name: "wall_slide" });
				self.physics.set_speed(0, 0);
				self.physics.set_grav(new Vec2(0,0));
				self.dash_jump = false;
				self.current_hspd = self.states.walk.speed;	
				self.states.dash_air.curr_dashes = 0;
				double_jumps = self.states.jump.count - 1;
				WORLD.play_sound("land");
			},
			leave: function() {	
				self.physics.update_gravity();
				self.physics.set_vspd(0);
			},
			step: function() {
				self.timer++;
				if(self.timer == 6){
					self.physics.set_vspd(self.states.wall_slide.speed);
				}
				self.set_hor_movement();	
			}
		})
		.add("wall_jump", {
			enter: function() {
				WORLD.play_sound(self.states.wall_jump.sound);
				self.input.__useBuffer = false;
				self.timer = CURRENT_FRAME;
				self.publish("animation_play", { name: "wall_jump" });
				self.dir = self.get_wall_jump_dir();
				if (self.dir != 0) self.publish("animation_xscale", self.dir)
				self.physics.set_speed(0, 0);
				self.states.dash_air.curr_dashes = 0;
				double_jumps = self.states.jump.count - 1;
				self.physics.set_grav(new Vec2(0,0));
			},
			leave: function() {	
				self.physics.update_gravity();
			},
			step: function() {
				if (self.timer + self.states.wall_jump.launch_lock < CURRENT_FRAME){
					self.set_hor_movement();	
				} else if (self.timer + self.states.wall_jump.launch_lock == CURRENT_FRAME){
					self.input.__useBuffer = true;
					self.publish("animation_play", { name: "jump", frame: 15, reset: false});
					self.set_hor_movement();
				}
				
				if (self.timer + self.states.wall_jump.wall_stick == CURRENT_FRAME) {
					self.physics.update_gravity();
					
					var _inst = self.get_instance();
					
					if (self.input.get_input("dash") && self.fsm.state_exists("dash") && global.settings.extra_particles) {
						WORLD.spawn_particle(new DashUpParticle(_inst.x, _inst.y + 16, self.dir))
					} else {
						WORLD.spawn_particle(new SparkParticle(_inst.x + 24 * self.dir, _inst.y + 16, self.dir))
					}
					
					if (self.input.get_input("dash") && self.fsm.state_exists("dash")) {
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
		.add_transition("t_jump", ["air"], "wall_jump", function() { return self.get_wall_jump_dir() != 0; })
		.add_wildcard_transition("t_jump", "wall_jump", function() { return self.get_wall_jump_dir() != 0; })
		.add_transition("t_transition", "fall", "wall_slide", function(){ return self.wall_slide_possible();})
		.add_transition("t_transition", "wall_jump", "fall", function() { return (!self.input.get_input("jump") || self.physics.is_on_ceil()) && self.timer > 10 || self.physics.get_vspd() > 0; })
		.add_transition("t_transition", "wall_slide", "fall", function() { return self.hdir != self.dir || !self.wall_slide_possible(); })
		.add_transition("t_jump", "wall_slide", "wall_jump")
		
	}
}
	
function add_melee_state(_entity){
	with(_entity){
		var _melee = {
			animation: "undefined", 
			priority: 0, 
			hitbox_scale: new Vec2(0,0), 
			hitbox_offset: new Vec2(0,0), 
			damage: 1, 
			proj: undefined, 
			reset_velocity: false,
			grounded: false
		}
		
		variable_struct_set(self.states, "melee", variable_clone(_melee));
		variable_struct_set(global.availible_characters[global.character_index].states, "melee", variable_clone(_melee));
		
		self.fsm.add("melee", {
			enter: function() {
				self.publish("animation_play", { name: self.states.melee.animation, reset: true});
				
				self.get_instance().y = ceil(self.get_instance().y)
				
				//create the actual saber
				
				var _tags = ["player"];
				
				var _melee_hitbox = PROJECTILES.create_melee_hitbox(self.get_instance().x, self.get_instance().y, self.dir, MeleeProjectile, get(ComponentWeaponUse), _tags, self.states.melee.animation, 12);
			
				_melee_hitbox.code.comboiness = self.states.melee.priority;
				_melee_hitbox.hitbox = self.states.melee.hitbox_scale;
				_melee_hitbox.hitbox_offset = self.states.melee.hitbox_offset;
				_melee_hitbox.code.damage = self.states.melee.damage;
				_melee_hitbox.code.boss_damage = self.states.melee.damage;
				
				self.states.melee.proj = _melee_hitbox;
				
				self.states.melee.grounded = self.physics.is_on_floor();
				
				if(self.physics.is_on_floor() && self.states.melee.reset_velocity){
					self.physics.set_hspd(0);
				}
			},
			leave: function() {	
				PROJECTILES.destroy_projectile(self.states.melee.proj.code);
				self.states.melee.proj = undefined;
				self.states.melee.animation = "undefined"
			},
			step: function() {
				if(!self.physics.is_on_floor()){
					self.set_hor_movement();
				}
			}
		})
		
		self.fsm.add("melee_end", {
			enter: function() {
				var _frame = self.find("animation").animation.get_props(self.states.melee.animation + "_end").keyframes[0].frame;
				
				self.publish("animation_play", { name: "atk_1_end", reset: true, frame: _frame});
				self.states.melee.animation = "undefined"
				
				if(self.physics.is_on_floor()){
					self.physics.set_hspd(0);
				}
			},
			leave: function(){
				
				log(self.current_hspd);
			}, 
			step: function() {
				if(!self.physics.is_on_floor()){
					self.set_hor_movement();
				}
			}
		})
		.add_transition("t_animation_end", "melee", "melee_end")
		.add_transition("t_transition", "melee", "fall", function(){ return self.physics.is_on_floor() != self.states.melee.grounded;})
		.add_transition("t_transition", "melee_end", "walk", function(){ return self.hdir != 0 && self.physics.is_on_floor(self.ground_distance);})
		.add_transition("t_animation_end", "melee_end", "idle", function(){return self.physics.is_on_floor(self.ground_distance)})
		.add_transition("t_animation_end", "melee_end", "fall", function(){return !self.physics.is_on_floor(self.ground_distance)})
		.add_transition("t_jump", ["melee", "melee_end"], "jump", function() {
			if can_jump_check(){
			
				self.states.melee.animation = "undefined"	
				return true;
			}
			return false;
		})
	}
}

function add_aimable_state(_entity){
	with(_entity){
		var _aiming = {return_delay: 35, shot_start_time: -1}
		
		variable_struct_set(self.states, "aiming", variable_clone(_aiming));
		variable_struct_set(global.availible_characters[global.character_index].states, "aiming", variable_clone(_aiming));
		
		self.fsm.add("aim", {
			enter: function() {
				self.timer = CURRENT_FRAME;
				self.shot_start_time = CURRENT_FRAME;
				self.physics.set_hspd(0);
				self.physics.set_vspd(0);
				self.physics.set_grav(new Vec2(0,0));
			},
			leave: function() {	
				self.physics.update_gravity();
			},
			step: function() {
				if(CURRENT_FRAME > shot_start_time + self.states.aiming.return_delay)
					self.physics.set_grav(new Vec2(0,0.125));
			}
		})
		.add_transition("t_transition", "aim", "walk", function(){ return self.hdir != 0 && self.timer + self.states.aiming.return_delay < CURRENT_FRAME;})
		.add_transition("t_jump", "aim", "jump", function() { return can_jump_check(); })
		.add_transition("t_transition", "aim", "fall", function() { return self.timer + self.states.aiming.return_delay < CURRENT_FRAME && !self.physics.is_on_floor(); })
		.add_transition("t_transition", "aim", "idle", function() { return self.timer + self.states.aiming.return_delay < CURRENT_FRAME && self.physics.is_on_floor(); })
	}
}
	
function add_air_dash(_entity, _armor = undefined){
	with(_entity){
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
				self.physics.update_gravity();
			}
		})
		.add("dash_end_air", {
			enter: function() {
				self.timer = 0;
				self.dash_dir = self.dir;
				self.publish("animation_play", { name: self.states.dash_air.animation + "_end" });
				self.dash_tapped = false;
			},
			step: function() {
				self.set_hor_movement();
			},
			leave: function(){
				self.physics.update_gravity();
			}
		})
		.add("land", {
			enter: function() {
				var _land = WORLD.play_sound(self.states.land.sound);
				self.publish("animation_play", { name: "land" });
				self.input.__useBuffer = true;
				self.states.dash_air.curr_dashes = 0;
			},
			leave: function() {
				self.dash_jump = false;	
			}
		})
		.add_wildcard_transition("t_dash", "dash_air", function() { return !self.physics.check_wall(self.dash_dir) && !self.physics.is_on_floor() && self.states.dash_air.curr_dashes < self.states.dash_air.max_dashes && (!self.fsm.state_exists("variable_dash") || !self.input.get_input("up")); })
		.add_transition("t_dash_end", "dash_air", "dash_end_air", function() { return self.physics.is_on_floor(); })
		.add_transition("t_transition", "dash_air", "dash_end_air", function() 
			{ return (self.hdir != self.dash_dir && (self.hdir != 0 || self.dash_tapped)) || self.timer <= CURRENT_FRAME || (!self.dash_tapped && !self.input.get_input("dash")); })
		.add_transition("t_animation_end", "dash_end_air", "fall")
	}
}
	
function add_slide(_entity, _armor){
	with(_entity){
		struct_set(states, "slide", {speed: self.states.dash.speed, interval: self.states.dash.interval, animation: "slide", old_hitbox: noone})
		//log("GJNGIHIDUSBGHUBSDGHIBSUIBDSJHGBSHJGBDSGIBI SLIDE")
		self.fsm.add("slide", {
			enter: function() {//
				self.states.slide.old_hitbox = self.get_instance().mask_index;
				self.get_instance().mask_index = spr_slide_mask;
				self.physics.move_down(16)
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
				self.physics.move_down(16)
				if(CURRENT_FRAME mod 6 == 0){
					var _inst = self.get_instance();
					WORLD.spawn_particle(new DustParticle(_inst.x- 16 * self.dir, _inst.y + 8, self.dir))
				}
			},
			leave: function() {
				self.physics.move_down(16)
				if(self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y - 1, obj_square_16) && 
					!self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y + 1, obj_square_16))
						self.get_instance().y += 16
					
				self.physics.update_gravity();
				self.get_instance().mask_index = self.states.slide.old_hitbox;
			}
		})
		.add("slide_end", {
			enter: function() {
				self.current_hspd = self.states.walk.speed;
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
				
			return _can_bail && 
			(
				(self.hdir != self.dash_dir &&
					(self.hdir != 0 || self.dash_tapped)
					) || self.timer <= CURRENT_FRAME || 
						(!self.dash_tapped && 
							!(self.input.get_input("down") || self.input.get_input("dash") && !self.fsm.state_exists("dash")
							)
						)
					
			); })
		
		.add_transition("t_animation_end", "slide_end", "idle")
		.add_transition("t_jump", "slide", "jump", function() { return self.can_jump_check() && !self.physics.is_on_ceil(); })
		.add_transition("t_transition", "slide", "slide_end", function() 
		{ return (self.hdir != self.dash_dir && (self.hdir != 0 || self.dash_tapped)) || self.timer <= CURRENT_FRAME || (!self.dash_tapped && (!self.input.get_input("dash") && !self.input.get_input("down"))) && !self.physics.is_on_ceil(); })
		.add_transition("t_transition", ["land"], "slide", function() { return self.input.get_input("dash") && global.settings.Dash_On_Land })
		.add_transition("t_transition", ["jump", "idle", "walk", "crouch"], "slide", function() { return self.input.get_input("jump") && self.input.get_input("down") })
		.add_transition("t_dash_end", "slide", "fall", function() { return !self.physics.is_on_floor(self.ground_distance + 1); })
		.add_transition("t_dash_end", "slide", "slide_end", function() { return self.physics.is_on_floor(self.ground_distance + 1) && !self.physics.is_on_ceil(); })
		.add_wildcard_transition("t_dash", "slide", function() { return !self.physics.check_wall(self.dash_dir) && self.physics.is_on_floor(self.ground_distance) && !self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_square_16); })
	
	}
}
	
function add_mach_dash(_entity, _falcon_flight = undefined){
	_entity.states.dash.speed *= 1.05;
	with(_entity){
		struct_set(states, "mach_dash", {
			speed: 1298/256, //1298/256, 
			interval: 25, //25,
			max_dashes: 1, 
			curr_dashes: 0, 
			animation: "mach_dash", 
			angle: new Vec2(0,1), 
			only_cardinals: true, 
			golden: false,
			change_direction: false,
			has_time_limit: false,
			time_limit: 5
		})
			
		if(keyboard_check(ord("P"))){
			self.states.mach_dash.only_cardinals = false;
			self.states.mach_dash.interval *= 1.25;
			self.states.mach_dash.speed *= 1.25;
		}
			
		//falcon flight emulation
		if(keyboard_check(ord("N")) || _falcon_flight){
			self.states.mach_dash.change_direction = true;
			self.states.mach_dash.only_cardinals = false;
			self.states.mach_dash.speed = self.states.walk.speed;
			self.states.mach_dash.interval *= 12.5;
			self.states.mach_dash.animation = "fly"
			self.states.mach_dash.has_time_limit = true
		}
			
		self.get_instance().components.get(ComponentWeaponUse).shoot_inputs = ["shoot", "shoot2", "shoot3"]
			
		self.fsm.add("mach_dash", {
			enter: function() {//
				WORLD.play_sound("dash");
				if(!self.states.mach_dash.golden)
					self.states.dash_air.curr_dashes++;
				var _inst = self.get_instance()
					
				self.current_hspd = self.states.mach_dash.speed;	
				self.physics.terminal_velocity = 1025;
					
				var _input_dir = new Vec2(self.hdir, self.vdir);
				if (_input_dir.x == 0 && _input_dir.y == 0) _input_dir = new Vec2(self.dir, 0);
					
				if(_input_dir.x == 0 && _input_dir.y == -1){
					self.publish("animation_play", { name: self.states.mach_dash.animation + "_up" });
					WORLD.spawn_particle(new DashUpParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
				} else if(_input_dir.x == 0 && _input_dir.y == 1){
					self.publish("animation_play", { name: self.states.mach_dash.animation + "_up" });
					self.publish("animation_yscale", -1);
					self.publish("animation_xscale", self.dir * -1);
					WORLD.spawn_particle(new DashDownParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
				} else {
					self.publish("animation_play", { name: self.states.mach_dash.animation });
					self.dir = _input_dir.x;
						
					if(self.states.mach_dash.only_cardinals)
						_input_dir = new Vec2(_input_dir.x, 0);
						
					self.publish("animation_xscale", self.dir)
					self.publish("animation_angle", 45 * (_input_dir.y * _input_dir.x))
					WORLD.spawn_particle(new DashParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
				}
					
				_input_dir = _input_dir.rotate(find("animation").rotation_angle)
					
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
					self.publish("animation_play", { name: self.states.mach_dash.animation + "_up" });
					self.publish("animation_yscale", 1);
				} else if(_input_dir.x == 0 && _input_dir.y == 1){
					self.publish("animation_play", { name: self.states.mach_dash.animation + "_up" });
					self.publish("animation_yscale", -1);
				} else {
					self.publish("animation_play", { name: self.states.mach_dash.animation });
					if(_input_dir.x != 0)
						self.dir = floor(_input_dir.x + 0.5);
						
					if(self.states.mach_dash.only_cardinals)
						_input_dir = new Vec2(_input_dir.x, 0);
						
					self.publish("animation_xscale", self.dir == 0 ? 1 : self.dir)
					self.publish("animation_angle", 45 * (_input_dir.y * _input_dir.x))
					self.publish("animation_yscale", 1);
				}
					
				self.states.mach_dash.angle = _input_dir;
					
				self.physics.set_speed(self.states.mach_dash.angle.x * self.states.mach_dash.speed, self.states.mach_dash.angle.y * self.states.mach_dash.speed);
					
			},
			leave: function() {
				self.physics.update_gravity();
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
				self.timer = CURRENT_FRAME;
			},
			step: function() {
				if(self.input.get_input_released("dash") || self.input.get_input_released("shoot4") || (self.states.mach_dash.has_time_limit && CURRENT_FRAME > self.timer + self.states.mach_dash.time_limit))
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
		
		.add("land", {
			enter: function() {
				var _land = WORLD.play_sound(self.states.land.sound);
				self.publish("animation_play", { name: "land" });
				self.input.__useBuffer = true;
				self.states.dash_air.curr_dashes = 0;
			},
			leave: function() {
				self.dash_jump = false;	
			}
		})
		.add_wildcard_transition("t_dash", "dash_hold", function() { return !self.physics.is_on_floor() && self.states.dash_air.curr_dashes < self.states.dash_air.max_dashes; })
		.add_transition("t_transition", "mach_dash", "fall", function() 
			{ return self.timer <= CURRENT_FRAME; })
		.add_wildcard_transition("t_transition", "dash_hold", function() {return self.input.get_input_pressed_raw("shoot4") && self.states.dash_air.curr_dashes < self.states.dash_air.max_dashes;});
	}
}
	
function add_falcon_flight(_entity){
	with(_entity){
		
		struct_set(states, "fly", {
			speed: self.states.walk.speed,
			animation: "fly",
			anim_timer: 3,
			fly_timer: 300,
		})
		
		fsm.add("fly", {
			enter: function(){
				self.timer = CURRENT_FRAME
						self.publish("animation_play", { name: self.states.fly.animation + "_start" });
			},
			step: function(){
				var _input_dir = new Vec2(self.hdir, self.vdir);
				
				if(CURRENT_FRAME - self.timer > self.states.fly.anim_timer){
					if(_input_dir.y < 0){
						self.publish("animation_play", { name: self.states.fly.animation + "_up" });
					} else if(_input_dir.y > 0){
						self.publish("animation_play", { name: self.states.fly.animation + "_down" });
					} else {
						self.publish("animation_play", { name: self.states.fly.animation });
					}
				}
				
				if(_input_dir.x != 0){
					self.dir = sign(_input_dir.x)
					self.publish("animation_xscale", self.dir);
				}
				
				self.physics.set_speed(_input_dir.x * self.states.walk.speed, _input_dir.y * self.states.walk.speed + sin(CURRENT_FRAME / 4) / 3)
			}
			
		})
		.add_wildcard_transition("t_dash", "fly", function() { return !self.physics.is_on_floor() && self.states.dash_air.curr_dashes < self.states.dash_air.max_dashes; })
		.add_transition("t_transition", "fly", "fall", function() 
			{ return self.timer <= CURRENT_FRAME - self.states.fly.fly_timer; })
		.add_wildcard_transition("t_transition", "fly", function() {return self.input.get_input_pressed_raw("jump") && !self.physics.is_on_floor() && self.states.dash_air.curr_dashes < self.states.dash_air.max_dashes;});
	}
}
	
function remove_dash(_entity){
	with(_entity){
		if(variable_struct_exists(self.fsm, "remove")){
			if (fsm.get_current_state() == "dash" || fsm.get_current_state() == "dash_end")
				self.fsm.change("idle")
			self.fsm.remove("dash")
			self.fsm.remove("dash_end")
			
			log("removed?")
		} else {
			self.states.dash.interval = 0;
			self.states.dash.speed = self.states.walk.speed;
		} 
	}
}
	
function add_variable_dash(_entity){
	with(_entity){
		
		struct_set(states, "variable_dash", {
			speed: 5,
			animation: "dash_up",
			interval: self.states.dash_air.interval
		})
		
		fsm.add("variable_dash_start", {
			enter: function(){
				if(global.player_data.quick_up_dash) //done until i make the setting for quick up dash
					self.publish("animation_play", { name: self.states.variable_dash.animation + "_start_quick" });
				else 
					self.publish("animation_play", { name: self.states.variable_dash.animation + "_start" });
				self.physics.set_grav(new Vec2(0,0))
				self.physics.set_speed(0,-0.5)
				self.states.dash_air.curr_dashes++;
			},
			step: function(){
				
			}
		})
		.add("variable_dash", {
			enter: function(){
				var _inst = self.get_instance();
				WORLD.spawn_particle(new DashUpParticle(_inst.x - self.dir * 8, _inst.y + 16, self.dir))
				WORLD.play_sound("dash");
				
				self.timer = CURRENT_FRAME + self.states.variable_dash.interval;
				self.publish("animation_play", { name: self.states.variable_dash.animation, reset_frame: false });
				self.physics.set_vspd(self.states.variable_dash.speed * -1)
			},
			leave: function(){
				self.physics.update_gravity();
			}
		})
		.add_transition("t_transition", ["idle", "walk", "dash", "air", "dash_air"],"variable_dash_start", function(){return self.input.get_input("up") && self.input.get_input("dash") && self.states.dash_air.curr_dashes < self.states.dash_air.max_dashes})
		.add_transition("t_animation_end", "variable_dash_start", "variable_dash")
		.add_transition("t_transition", "variable_dash", "fall", function() 
			{ return self.timer <= CURRENT_FRAME || (!self.dash_tapped && !self.input.get_input("dash")); })
		.add_transition("t_transition", "variable_dash_start", "dash_end_air", function() 
			{ return (!self.dash_tapped && !self.input.get_input("dash")); })
	}
}
	
function add_high_jump(_entity){
	with(_entity){
		
		struct_set(states, "high_jump", {
			speed: 8,
			animation: "jump",
			interval: 30
		})
		
		fsm.add("high_jump", {
			enter: function(){
				var _inst = self.get_instance();
				WORLD.spawn_particle(new DashUpParticle(_inst.x - self.dir * 8, _inst.y + 16, self.dir))
				WORLD.play_sound("jump");
				
				self.physics.set_grav(new Vec2(0,0))
				self.physics.set_speed(0,self.states.high_jump.speed * -1)
				
				self.timer = CURRENT_FRAME + self.states.high_jump.interval;
				self.publish("animation_play", { name: "jump" });
			},
			leave: function(){
				self.physics.update_gravity();
			}
		})
		.add_transition("t_transition", "jump", "high_jump", function() 
			{ return self.physics.is_on_floor(16) && self.input.get_input("jump") && self.input.get_input("up") })
		.add_transition("t_transition", "high_jump", "fall", function() 
			{ return self.timer < CURRENT_FRAME })
	}
}

function add_ceil_cling(_entity){
	with(_entity){
		
		struct_set(states, "high_jump", {
			speed: 8,
			animation: "jump",
			interval: 30
		})
		
		//PROJECTILES.create_projectile(_x, _y, _dir, _shot_data, self, _tags, self.damage_increase);
		
		fsm.add("ceil_cling", {
			enter: function(){
				var _inst = self.get_instance();
				
				self.physics.set_grav(new Vec2(0,0))
				self.physics.set_speed(0,0)
				
				self.timer = CURRENT_FRAME + self.states.high_jump.interval;
				if fsm.get_previous_state() != "ceil_cling_shoot"
				self.publish("animation_play", { name: "ceil_cling" });
			},
			leave: function(){
				self.physics.update_gravity();
			}
		})
		.add("ceil_cling_shoot", {
			enter: function(){
				var _inst = self.get_instance();
				self.physics.set_grav(new Vec2(0,0))
				self.physics.set_speed(0,0)
				
				self.timer = CURRENT_FRAME + 5
				self.publish("animation_play", { name: "ceil_cling_shoot" });
				PROJECTILES.create_projectile(_inst.x + dir * 8, _inst.y + 16, 1, xBusterShadowRoofData, self, ["player"], 0);
			},
			leave: function(){
			}
		})
		.add_transition("t_transition", "high_jump", "ceil_cling", function() 
			{ return self.physics.is_on_ceil() })
		.add_transition("t_transition", "ceil_cling", "ceil_cling_shoot", function() 
			{ return self.input.get_input("shoot") })
		.add_transition("t_transition", "ceil_cling_shoot", "ceil_cling", function() 
			{ return self.timer < CURRENT_FRAME })
	}
}
	
function add_hover(_entity){
	
}

function add_glide(_entity){
	
}