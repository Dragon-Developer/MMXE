function ComponentPlayerMove() : ComponentBase() constructor {
	self.add_tags("player");
	#region variables
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
	self.initial_y = -1;
	self.states = {};
	self.ground_distance = 3;
	self.double_jumps = 0;
	self.left_manually = false
	
	self.timer = 0;
	
	log(global.character_index)
	
	self.character = global.availible_characters[global.character_index]
	#endregion
	
	#region serializer
	self.serializer
		.addVariable("dir")
		.addVariable("timer")
		.addVariable("current_hspd")
		.addVariable("dash_dir")
		.addVariable("dash_jump")
		.addVariable("dash_tapped")
		.addVariable("armor_parts")
		.addVariable("paused")
		.addVariable("locked")
		.addCustom("double_tap")
		.addCustom("fsm");
		#endregion
	
	self.reset_state_variables = function(){
		self.states = variable_clone(global.availible_characters[global.character_index].states);
	}
	
	// Finite State Machine initialization
	self.add_base_state_machine = function(){
		
	self.reset_state_variables();
	self.fsm = new SnowState("init", true);
	self.fsm
		.history_enable()
		.history_set_max_size(10)
		.add("init", {
			enter: function() {
				self.publish("animation_play", { name: "idle" });
				
				
			}
		})
		.add("teleport_in", {
			enter: function() {
				self.publish("animation_play", { name: "tp_in" , reset: false});
				WORLD.play_sound("tp in");
				self.physics.set_speed(0, 0);
				self.physics.set_grav(new Vec2(0,0));
				self.physics.does_collisions = false;
				self.timer = (GAME_H / self.states.intro.speed) + CURRENT_FRAME + 1
			},
			step: function(){
				self.get_instance().y += self.states.intro.speed;
				
			},
			leave: function(){
				self.physics.set_speed(0, 0);
				self.physics.set_grav(self.physics.grav_default);
				self.physics.does_collisions = true;
				
				with(obj_camera){
					components.publish("target_set", other.get_instance());	
				}
			}
		})
		.add("intro", {
			enter: function() {
				var _frame = self.find("animation").animation.get_props(self.states.intro.animation).keyframes[0].frame;
				self.publish("animation_play", { name: self.states.intro.animation, frame: _frame, reset: false});
			}
		})
		.add("intro_end", {
			enter: function() {
				
				var _frame = self.find("animation").animation.get_props(self.states.intro.animation + "_end").keyframes[0].frame;
				self.publish("animation_play", { name: self.states.intro.animation + "_end", frame: _frame, reset: false});
			}
		})
		.add("idle", {
			enter: function() {
				if(get(ComponentDamageable).health < get(ComponentDamageable).health_max / 3)
					self.publish("animation_play", { name: "critical", reset: false, frame: 0 });
				else
					self.publish("animation_play", { name: "idle", reset: false, frame: 0 });
				self.physics.set_speed(0, 0);
				self.get_instance().y = ceil(self.get_instance().y)
			},draw: function(){
			}
		})
		.add("walk", {
			enter: function() {
				//self.publish("animation_play", { name: "walk" });
				self.publish("animation_play", { name: self.states.walk.animation });
				self.current_hspd = self.states.walk.speed;
				self.timer = CURRENT_FRAME + 1;
			},
			step: function() {
				self.set_hor_movement(self.hdir, self.timer);	
			}
		})
		.add("air", {
			step: function() {
				self.set_hor_movement();
			}
		})
		.add_child("air", "jump", {
			enter: function() {
				var _inst = self.get_instance();
				if(self.input.get_input("down") && self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y + 1, obj_collision_semisolid)){
					self.fsm.change("fall");
					_inst.y += 3;
					return;
				}
				
				if(self.physics.is_on_floor()){
					self.publish("animation_play", { name: self.states.jump.animation });
					double_jumps = self.states.jump.count - 1;
				}else{ 
					double_jumps--;
					self.publish("animation_play", { name: self.states.jump.double_jump_animation });
					
					if(global.settings.extra_particles)
						WORLD.spawn_particle(new DustParticle(_inst.x, _inst.y + 16, self.dir))
				}
				
				WORLD.play_sound(self.states.jump.sound);
				self.input.__useBuffer = false;
				self.fsm.inherit();
				//self.publish("animation_play", { name: "jump" });
				self.physics.set_vspd(-self.states.jump.strength);
				if ((self.fsm.get_previous_state() == "dash" || self.fsm.get_previous_state() == "dash_air" || self.input.get_input("dash") && global.settings.PSX_Style_Dash_Jumping) && self.fsm.state_exists("dash")){
					self.current_hspd = self.states.dash.speed;
					if(global.settings.extra_particles)
						WORLD.spawn_particle(new SparkParticle(_inst.x, _inst.y + 16, self.dir))
				}
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
			},
			leave: function() {
				self.get_instance().y = ceil(self.get_instance().y)
			}
		})
		.add("land", {
			enter: function() {
				WORLD.play_sound(self.states.land.sound);
				self.publish("animation_play", { name: "land" });
				self.input.__useBuffer = true;
				self.physics.move_down(3, obj_square_16, 0)
				self.get_instance().y = ceil(self.get_instance().y)
			},
			leave: function() {
				self.dash_jump = false;	
				self.get_instance().y = ceil(self.get_instance().y)
				
				var _rot = find("animation").rotation_angle mod 360;
				var _offset = new Vec2(0,8);
				_offset = _offset.rotate(_rot);
				
				if(!self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, self.physics.objects.block) && self.physics.check_place_meeting(self.get_instance().x + _offset.x, self.get_instance().y + _offset.y, self.physics.objects.block)){
					try{
						var _block = self.physics.get_place_meeting(self.get_instance().x + _offset.x, self.get_instance().y + _offset.y, self.physics.objects.block);
						if(_rot == 0)
							self.get_instance().y = _block.y - 16;
						else if(_rot == 90)
							self.get_instance().x = _block.x - 16;
						else if(_rot == 180)
							self.get_instance().y = _block.y + 16 + _block.image_yscale * 16;
						else if(_rot == 270)
							self.get_instance().x = _block.x + 16 + _block.image_xscale * 16;
					}
				}
			}
		})
		.add("custom", {})
		.add("crouch", {
			enter: function() {
				self.publish("animation_play", { name: "crouch" });
				self.physics.set_speed(0, 0);
				self.publish("on_crouch", false);	
				self.get_instance().mask_index = spr_slide_mask;
			},
			step: function(){
				if(self.hdir != 0){
					self.dir = self.hdir;
					self.publish("animation_xscale", self.hdir)
				}
				
			},
			leave: function() {
				self.publish("on_crouch", false);	
				self.get_instance().mask_index = spr_player_mask;
			}
		})
		.add("pose", {
			enter: function(){
				self.publish("animation_play", { name: "complete" });
				self.physics.set_speed(0, 0);
				WORLD.play_sound("full_charge");
				var _inst = self.get_instance();
				WORLD.spawn_particle(new CompleteParticle(_inst.x, _inst.y - 24, self.dir))
			},
			leave: function(){
				locked = false;
			}
		})
		.add("complete", {
			enter: function(){
				self.publish("animation_play", { name: "complete" });
				self.physics.set_speed(0, 0);
				WORLD.play_sound("full_charge");
				var _inst = self.get_instance();
				WORLD.spawn_particle(new CompleteParticle(_inst.x, _inst.y - 24, self.dir))
			}
		})
		.add("outro", {
			enter: function(){
				with(obj_camera){
					components.get(ComponentCamera).target = noone;
				}
				self.publish("animation_play", { name: "outro" });
			}
		})
		.add("leave", {
			enter: function(){
				self.publish("animation_play", { name: "tp_in" , reset: false});
				WORLD.play_sound("tp out");
				//self.publish("animation_play", { name: "leave" });
				self.physics.set_grav(new Vec2(0,0));
				var _inst = self.get_instance();
				var _cam = instance_nearest(_inst.x, _inst.y, obj_camera)
				_cam.components.get(ComponentCamera).bounds = noone;
				self.timer = CURRENT_FRAME + 75;
				global.stage_time = CURRENT_FRAME - global.stage_time;
			},
			step: function(){
				var _inst = self.get_instance();
				_inst.y -= self.states.intro.speed;
				
				
				if(self.timer < CURRENT_FRAME){
					global.hit_count = get(ComponentDamageable).hit_amount;
					
					if(room == rm_intro)
						global.settings.Has_done_intro_stage = true;
					else if(room == rm_dynamos_hellhole)
						global.dynamo_race = false;
						
					if(!variable_struct_exists(global.player_data, "beaten_stages"))
						variable_struct_set(global.player_data, "beaten_stages", {})
						
					if(!variable_struct_exists(global.player_data.beaten_stages, room_get_name(room)) && !left_manually)
						variable_struct_set(global.player_data.beaten_stages, room_get_name(room), global.stage_time)
					else if(!left_manually && variable_struct_get(global.player_data.beaten_stages, room_get_name(room)) > global.stage_time || variable_struct_get(global.player_data.beaten_stages, room_get_name(room)) == 1){
						variable_struct_set(global.player_data.beaten_stages, room_get_name(room), global.stage_time)
					}
						
					JSON.save({
						settings: global.settings, 
						player_data: global.player_data
					},game_save_id + "save.json", true)
					
					if(global.settings.score_showcase && !left_manually) || (global.dynamo_race)
						room_transition_to(rm_score_showcase, 0, 24);
					else
						room_transition_to(rm_stage_select, 0, 24);
					
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
				self.physics.set_grav(new Vec2(0,0));
				self.find("animation").animation.__speed = 0;
				//self.publish("animation_play", { name: "ladder" });
			},
			leave: function(){
				self.physics.update_gravity();
				self.physics.set_vspd(0);
				self.find("animation").animation.__speed = 1;
			}
		})
		.add_child("ladder", "ladder_enter", {
			enter: function(){
				self.fsm.inherit();
				with(self.get_instance()){
					x = instance_nearest(x,y,obj_ladder).x + 16;
				}
				self.publish("animation_play", { name: "ladder_enter" });
				self.find("animation").animation.__speed = 1;
			},
			step: function(){
				self.get_instance().y += self.vdir * self.states.ladder.speed / 2;
			}
		})
		.add_child("ladder", "ladder_move", {
			enter: function(){
				self.fsm.inherit();
				self.publish("animation_play", { name: "ladder_move" });
				self.find("animation").animation.__speed = 1;
			},
			step: function(){
				self.get_instance().y += self.vdir * self.states.ladder.speed;
			}
		})
		.add_child("ladder", "ladder_idle", {
			enter: function(){
				self.fsm.inherit();
				self.publish("animation_play", { name: "ladder_move" });
				self.find("animation").animation.__speed = 0;
			}
		})
		.add("ladder_exit", {
			enter: function(){
				self.find("animation").animation.__speed = 1;
				self.publish("animation_play", { name: "ladder_exit" });
				
				if(self.vdir > 0)
					self.fsm.change("fall") 
				else {
					var _inst = self.get_instance()
					_inst.y = instance_nearest(_inst.x, _inst.y, obj_ladder).y - 17;
				}
			},
			leave: function(){
				self.physics.update_gravity();
				self.physics.set_vspd(0);
			}
		})
		.add("hurt", {
			enter: function(){
				WORLD.play_sound("hurt");
				self.publish("animation_play", { name: "hurt" });
				//self.physics.velocity = new Vec2(self.dir * self.states.hurt.speed,-2);
				self.physics.set_speed(self.dir * self.states.hurt.speed,-2)
			}
		})
		.add("death", {
			enter: function(){
				self.publish("animation_play", { name: "death" });
				self.physics.set_grav(new Vec2(0,0));
				self.physics.set_speed(0,0)
				self.input.__locked = true;
				//ENTITIES.remove_component(self.get(ComponentDamageable));
				self.timer = CURRENT_FRAME;
			},
			step: function(){
				var _inst = self.get_instance();
					
				if((CURRENT_FRAME - self.timer) > 40 && (CURRENT_FRAME - self.timer) < 184){
					WORLD.spawn_particle(new DeathBubbleParticle(_inst.x + 8 * self.dir, _inst.y, self.dir))
					for(var i = 0; i < array_length(global.availible_characters[global.character_index].default_palette); i++){
						var _col = global.availible_characters[global.character_index].default_palette[i]
						var _div = (1 + (CURRENT_FRAME - self.timer) / 184 * 2);
						log(_div)
						
						var _final_col = make_color_rgb(clamp(color_get_red(_col) * _div, 0, 255), clamp(color_get_green(_col) * _div, 0, 255), clamp(color_get_blue(_col) * _div, 0, 255))
						
						find("animation").set_palette_color(i, _final_col);
					};
				}
				
				switch (CURRENT_FRAME - self.timer) {
					case 30:
							for(var i = 0; i < array_length(global.availible_characters[global.character_index].default_palette); i++){
								find("animation").set_palette_color(i, #ffffff);
							};
							PARTICLES.depth = _inst.depth + 1;
						break;
					case 31:
						for(var i = 0; i < array_length(global.availible_characters[global.character_index].default_palette); i++){
							find("animation").set_palette_color(i, global.availible_characters[global.character_index].default_palette[i]);
						};
						break;
					case 34:
						WORLD.play_sound("die");
						break;
					case 199:
						WORLD.stop_music();
						break;
					case 92:
						room_transition_to(room, "white to black");
					break;
				}
			}
		})
		.add_transition("t_init", "init", "teleport_in")
		.add_transition("t_move_h", "idle", "walk", function() { return !self.physics.check_wall(self.hdir); })
		.add_transition("t_move_h", "land", "walk", function() { return !self.physics.check_wall(self.hdir) && !self.input.get_input("dash"); })
		.add_wildcard_transition("t_hurt", "hurt", function() { return self.get_wall_jump_dir() == 0; })
		.add_transition("t_jump", ["idle", "walk", "dash", "land", "dash_end", "crouch"], "jump", function() { return self.can_jump_check(); })
		.add_transition("t_jump", ["jump", "fall"], "jump", function() { return self.input.get_input_pressed_raw("jump") && double_jumps > 0; })
		.add_transition("t_crouch", "idle", "crouch")
		.add_wildcard_transition("t_custom", "custom")
		.add_transition("t_custom_end", "custom", "idle")
		.add_transition("t_custom_exit", "custom", "jump")
		.add_transition("t_animation_end", ["start", "land", "dash_end","ladder_exit", "hurt"], "idle")
		.add_transition("t_animation_end", "intro", "intro_end")
		.add_transition("t_animation_end", "intro_end", "idle")
		.add_transition("t_animation_end", "complete", "outro")
		.add_transition("t_animation_end", "pose", "idle")
		.add_transition("t_animation_end", "outro", "leave")
		.add_transition("t_animation_end", "ladder_enter", "ladder_move")
		.add_transition("t_jump", ["ladder_idle", "ladder_move", "ladder_enter"], "jump")
		.add_wildcard_transition("t_dialouge", "idle")
		.add_transition("t_hadouken", "idle", "land")
		/*automatic transitions between states*/
		.add_transition("t_transition", "teleport_in", "intro", function() {return self.timer <= CURRENT_FRAME })
		.add_transition("t_transition", "walk", "idle", function() { return self.hdir == 0 || self.physics.check_wall(self.hdir); })
		.add_transition("t_transition", "crouch", "idle", function() { return !self.input.get_input("down"); })
		.add_transition("t_transition", "jump", "fall", function() { return !self.input.get_input("jump") || self.physics.is_on_ceil() || self.physics.get_vspd() >= 0; })
		.add_transition("t_transition", ["fall", "idle", "walk", "dash", "walljump"], "ladder_enter", function() { return self.vdir != 0 && self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_ladder) && !(self.physics.is_on_floor(4) && self.vdir > 0)})
		.add_transition("t_transition", "ladder_idle", "ladder_move", function() { return self.vdir != 0})
		.add_transition("t_transition", "ladder_move", "ladder_idle", function() { return self.vdir == 0})
		.add_transition("t_transition", ["ladder_idle", "ladder_move"], "ladder_exit", function() { 
			return !self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y - 8, obj_ladder) || self.physics.is_on_floor(4)
		})
		.add_transition("t_transition", ["fall", "wall_slide", "wall_jump"], "land", function() { return self.physics.is_on_floor(self.ground_distance); })
		.add_transition("t_transition", ["idle", "walk", "crouch", "land"], "fall", function() { return !self.physics.is_on_floor(self.ground_distance); })
		.add_wildcard_transition("t_complete", "complete")
	}
	
	self.wall_slide_possible = function(){
		return self.hdir != 0 && self.physics.check_wall(self.hdir);
	}
	
	self.get_wall_jump_dir = function() {
		if (self.physics.is_on_floor()) return 0;
		if (self.physics.check_wall(9)) return 1;
		if (self.physics.check_wall(-9)) return -1;
		return 0;
	}
	
	self.can_jump_check = function(){
		return self.physics.is_on_floor(self.ground_distance) && !self.physics.is_on_ceil(6);
	}
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
			self.motion = self.get(ComponentMotionInput) ?? new ComponentMotionInput();
			self.weaponHandler = self.parent.find("weaponHandler") ?? new ComponentWeaponUse();
		});
		self.subscribe("animation_end", function() {
			self.fsm.trigger("t_animation_end");	
		});
		self.subscribe("death", function() {
			if(self.fsm.get_current_state() != "death")
				self.fsm.change("death");
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
		self.subscribe("complete", function() {
			self.fsm.trigger("t_complete")
		});
	}
	
	// Initialization
	self.init = function() {
		global.stage_time = CURRENT_FRAME;
		global.hit_count = 0;
		
		array_foreach(global.availible_characters, function(_char, _index){
			global.availible_characters[_index] = {};
			with(global.availible_characters[_index]){
				script_execute(global.character_ref[_index]);
			}
		})
		
		self.character = variable_clone(global.availible_characters[global.character_index], 256);
		self.add_base_state_machine();
		self.character.init(self);
		self.fsm.trigger("t_init");
	}
	
	// Sets the player's horizontal movement based on direction
	self.set_hor_movement = function(_dir = self.hdir, _start_time = -1) {
		if(CURRENT_FRAME < _start_time) return;
		if (_dir != 0) self.dir = _dir;
		self.physics.set_hspd(self.current_hspd * _dir);
		if (_dir != 0) self.publish("animation_xscale", _dir)
	}
	
	// Double-tap detection system for activating dash
	self.double_tap = new MultiTap();
	self.double_tap.onPressed = function(_key, _times) {
		if (_times <= 1 || self.dir != _key || !global.settings.double_tap_dash) return;
		self.double_tap.reset();
		self.dash_dir = _key;
		self.dash_tapped = true;
		self.fsm.trigger("t_dash");
	}
	
	// Handles input and triggers attack transitions	
	self.step = function() {
		if (self.timescale != 1) self.timescale = 1
		if(!(paused || locked))self.default_step();
	}
	
	self.default_step = function(){
		self.motion.set_facing(self.dir)
		
		self.motion.step();
		
		//i love janky fixes
		if(self.fsm.get_current_state() == "death") {
			if (self.fsm.event_exists("step"))
				self.fsm.step();	
			
			return;
		}
		
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
		if (self.input.get_input_pressed_raw("dash") && !self.input.get_input_pressed("jump")) { 
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
			
		//if you want the pause menu, we make it here
		if(self.input.get_input_pressed_raw("pause")){
			with(obj_entity){
				if(variable_struct_exists(components, "__components"))
					array_foreach(components.__components, function(_comp){
						_comp.step_enabled = false;
					})
			}
			
			var _pause = ENTITIES.create_instance(obj_pause_menu);
			_pause.components.get(ComponentPauseMenu).input = input;
			_pause.components.get(ComponentPauseMenu).player = self.get_instance();
		}
	}
		
	self.draw = function(){
		if (self.fsm.event_exists("draw"))
			self.fsm.draw();	
			
		if !global.debug return;
		
		if(variable_struct_exists(self, "hdir"))
			draw_string(string(self.hdir), self.get_instance().x, self.get_instance().y - 32)
		if(variable_struct_exists(self, "vdir"))
			draw_string(string(self.vdir), self.get_instance().x, self.get_instance().y - 24)
		draw_string(string(self.physics.get_vspd()), self.get_instance().x + 16, self.get_instance().y - 24)
		draw_string(string(self.physics.get_hspd()), self.get_instance().x + 16, self.get_instance().y - 32)
		draw_string(string(self.get_instance().x), self.get_instance().x - 64, self.get_instance().y - 24)
		draw_string(string(self.get_instance().y), self.get_instance().x - 64, self.get_instance().y - 32)
		draw_string(string(locked), self.get_instance().x + 64, self.get_instance().y - 48)
		draw_string(string(input.__locked), self.get_instance().x + 64, self.get_instance().y - 64)
		draw_string(string(fsm.get_current_state()), self.get_instance().x - 32, self.get_instance().y - 64)
	}
	
	self.draw_gui = function() {
		if !global.debug return;
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