function add_dash(_entity){
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
			},
			step: function() {
				self.set_hor_movement(self.dash_dir);
				if(CURRENT_FRAME >= self.timer - self.states.dash.interval + 2)
					self.current_hspd = self.states.dash.speed;	
				if(CURRENT_FRAME mod 6 == 0){
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
	
function add_wall_jump(_entity){
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
					self.physics.set_vspd(2);
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
					self.input.__useBuffer = true;
					self.publish("animation_play", { name: "jump", frame: 10, reset: false});
					self.set_hor_movement();
				} else if (self.timer + 7 < CURRENT_FRAME) {
					//please this looks so much better
					//self.publish("animation_play_at_loop", { name: "jump", frame: 10});
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
				
				//create the actual saber
				
				var _tags = [];
				
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
				
				self.publish("animation_play", { name: self.states.melee.animation + "_end", reset: true, frame: _frame});
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
		var _aiming = {return_delay: 20}
		
		variable_struct_set(self.states, "aiming", variable_clone(_aiming));
		variable_struct_set(global.availible_characters[global.character_index].states, "aiming", variable_clone(_aiming));
		
		self.fsm.add("aim", {
			enter: function() {
				self.timer = CURRENT_FRAME;
				self.physics.set_hspd(0);
				self.physics.set_vspd(0);
				self.physics.set_grav(new Vec2(0,0));
			},
			leave: function() {	
				self.physics.set_grav(new Vec2(0,0.25));
			},
			step: function() {
				
			}
		})
		.add_transition("t_transition", "aim", "walk", function(){ return self.hdir != 0 && self.timer + self.states.aiming.return_delay < CURRENT_FRAME;})
		.add_transition("t_jump", "aim", "jump", function() { return can_jump_check(); })
		.add_transition("t_transition", "aim", "fall", function() { return self.timer + self.states.aiming.return_delay < CURRENT_FRAME && !self.physics.is_on_floor(); })
		.add_transition("t_transition", "aim", "idle", function() { return self.timer + self.states.aiming.return_delay < CURRENT_FRAME && self.physics.is_on_floor(); })
	}
}
	
function add_air_dash(_entity, _armor){
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
				self.physics.set_grav(new Vec2(0,0.25));
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
		.add_wildcard_transition("t_dash", "dash_air", function() { return !self.physics.check_wall(self.dash_dir) && !self.physics.is_on_floor() && self.states.dash_air.curr_dashes < self.states.dash_air.max_dashes; })
		.add_transition("t_dash_end", "dash_air", "dash_end_air", function() { return self.physics.is_on_floor(); })
		.add_transition("t_transition", "dash_air", "dash_end_air", function() 
			{ return (self.hdir != self.dash_dir && (self.hdir != 0 || self.dash_tapped)) || self.timer <= CURRENT_FRAME || (!self.dash_tapped && !self.input.get_input("dash")); })
		.add_transition("t_animation_end", "dash_end_air", "fall")
	}
}
	
function add_slide(_entity, _armor){
	with(_entity){
		struct_set(global.availible_characters[global.character_index].states, "slide", {speed: self.states.dash.speed, interval: self.states.dash.interval, animation: "slide", old_hitbox: noone})
		//log("GJNGIHIDUSBGHUBSDGHIBSUIBDSJHGBSHJGBDSGIBI SLIDE")
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
				if(CURRENT_FRAME mod 6 == 0){
					var _inst = self.get_instance();
					WORLD.spawn_particle(new DustParticle(_inst.x- 16 * self.dir, _inst.y + 8, self.dir))
				}
			},
			leave: function() {
				if(self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y - 1, obj_square_16) && 
					!self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y + 1, obj_square_16))
						self.get_instance().y += 16
					
				self.physics.set_grav(new Vec2(0,0.25));
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
		.add_transition("t_jump", "slide", "jump", function() { return self.can_jump_check(); })
		.add_transition("t_transition", "slide", "slide_end", function() 
		{ return (self.hdir != self.dash_dir && (self.hdir != 0 || self.dash_tapped)) || self.timer <= CURRENT_FRAME || (!self.dash_tapped && !self.input.get_input("dash")); })
		.add_transition("t_transition", ["land"], "slide", function() { return self.input.get_input("dash") && global.settings.Dash_On_Land })
		.add_transition("t_dash_end", "slide", "fall", function() { return !self.physics.is_on_floor(self.ground_distance + 1); })
		.add_transition("t_dash_end", "slide", "slide_end", function() { return self.physics.is_on_floor(self.ground_distance + 1); })
		.add_wildcard_transition("t_dash", "slide", function() { return !self.physics.check_wall(self.dash_dir) && self.physics.is_on_floor(self.ground_distance) && !self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_square_16); })
	
	}
}