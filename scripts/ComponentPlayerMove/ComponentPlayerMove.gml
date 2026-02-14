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
	
	self.timer = 0;
	
	log(global.character_index)
	
	self.character = global.availible_characters[global.character_index]
	
	self.armor_parts = [];
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
				self.physics.set_grav(new Vec2(0,0.25));
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
				self.publish("animation_play", { name: "idle", reset: false, frame: 0 });
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
				WORLD.play_sound("jump");
				self.input.__useBuffer = false;
				self.fsm.inherit();
				//self.publish("animation_play", { name: "jump" });
				self.publish("animation_play", { name: self.states.jump.animation });
				self.physics.set_vspd(-self.states.jump.strength);
				if ((self.fsm.get_previous_state() == "dash" || self.fsm.get_previous_state() == "dash_air" || self.input.get_input("dash") && global.settings.PSX_Style_Dash_Jumping) && self.fsm.state_exists("dash")){
					var _inst = self.get_instance();
					self.current_hspd = self.states.dash.speed;
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
			}
		})
		.add("land", {
			enter: function() {
				var _land = WORLD.play_sound("land");
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
				//self.publish("animation_play", { name: "leave" });
				self.physics.set_grav(new Vec2(0,0));
				var _inst = self.get_instance();
				var _cam = instance_nearest(_inst.x, _inst.y, obj_camera)
				_cam.components.get(ComponentCamera).bounds = noone;
				self.timer = CURRENT_FRAME + 75;
			},
			step: function(){
				var _inst = self.get_instance();
				_inst.y -= self.states.intro.speed;
				
				
				if(self.timer < CURRENT_FRAME){
				if(room == rm_intro)
					global.settings.Has_done_intro_stage = true;
					JSON.save({
						settings: global.settings, 
						player_data: global.player_data
					},game_save_id + "save.json", true)
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
				self.fsm.change("ladder")
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
		.add("ladder_exit", {
			enter: function(){
				self.find("animation").animation.__speed = 1;
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
					// Light Palette
					case 30:
							for(var i = 0; i < array_length(global.availible_characters[global.character_index].default_palette); i++){
								find("animation").set_palette_color(i, #ffffff);
							};
							PARTICLES.depth = _inst.depth + 1;
						break;
					// Orbs
					case 31:
						for(var i = 0; i < array_length(global.availible_characters[global.character_index].default_palette); i++){
							find("animation").set_palette_color(i, global.availible_characters[global.character_index].default_palette[i]);
						};
						break;
					case 32:
						//player_create_orbs(8, 360 / 16);
						break;
					// Sound
					case 34:
						WORLD.play_sound("die");
						break;
					// Stop Sound
					case 199:
						WORLD.stop_music();
						break;
						
					//screen fades to white, THEN black!
					//will add transition mode for that
						
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
		.add_transition("t_jump", ["idle", "walk", "dash", "land", "dash_end"], "jump", function() { return self.can_jump_check(); })
		.add_transition("t_crouch", "idle", "crouch")
		.add_wildcard_transition("t_custom", "custom")
		.add_transition("t_custom_end", "custom", "idle")
		//.add_transition("t_custom", ["air", "walk"], "custom")  why does this line exist when the above line covers it
		.add_transition("t_custom_exit", "custom", "jump")
		.add_transition("t_animation_end", ["start", "land", "dash_end","ladder_exit", "hurt"], "idle")
		.add_transition("t_animation_end", "intro", "intro_end")
		.add_transition("t_animation_end", "intro_end", "idle")
		.add_transition("t_animation_end", "complete", "outro")
		.add_transition("t_animation_end", "outro", "leave")
		.add_transition("t_jump", ["ladder", "ladder_move"], "jump")
		.add_wildcard_transition("t_dialouge", "idle")
		.add_transition("t_hadouken", "idle", "land")
		//.add_wildcard_transition("t_hurt", "idle", function() { return !(self.get_wall_jump_dir() != 0 && !self.physics.is_on_floor()); })
		/*automatic transitions between states*/
		.add_transition("t_transition", "teleport_in", "intro", function() {return self.timer <= CURRENT_FRAME })
		.add_transition("t_transition", "walk", "idle", function() { return self.hdir == 0 || self.physics.check_wall(self.hdir); })
		.add_transition("t_transition", "crouch", "idle", function() { return !self.input.get_input("down"); })
		.add_transition("t_transition", "jump", "fall", function() { return !self.input.get_input("jump") || self.physics.is_on_ceil() || self.physics.get_vspd() >= 0; })
		.add_transition("t_transition", ["fall", "idle", "walk", "dash", "walljump"], "ladder_enter", function() { return self.vdir != 0 && self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_ladder)})
		.add_transition("t_transition", "ladder", "ladder_move", function() { return self.vdir != 0})
		.add_transition("t_transition", "ladder_move", "ladder", function() { return self.vdir == 0})
		.add_transition("t_transition", "ladder_move", "ladder", function() { return self.vdir == 0})
		.add_transition("t_transition", ["ladder", "ladder_move"], "ladder_exit", function() { 
			return !self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_ladder) || self.physics.is_on_floor()
		})
		.add_transition("t_transition", ["fall", "wall_slide", "wall_jump"], "land", function() { return self.physics.is_on_floor(); })
		.add_transition("t_transition", ["idle", "walk", "crouch"], "fall", function() { return !self.physics.is_on_floor(self.ground_distance); })
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
			//What the heck is the parent of this? is it the player object?
			self.weaponHandler = self.parent.find("weaponHandler") ?? new ComponentWeaponUse();
			
			motion
				.set_input(self.input)
			    .set_buttons(["shoot"])
			    .add_motion("hadouken", [2, 3, 6], "shoot", function() {
			        fsm.trigger("t_hadouken");
			    })
			    .add_motion("shoryuken", [6, 2, 3], "shoot", function() {
			        fsm.trigger("t_shoryuken");
			    });
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
		self.character = variable_clone(global.availible_characters[global.character_index], 256);
		self.armor_parts = variable_clone(global.armors[global.character_index],256);
		//self.apply_full_armor_set(self.armor_parts);
		self.add_base_state_machine();
		self.character.init(self);
		self.fsm.trigger("t_init");
	}
	
	self.apply_full_armor_set = function(_armors){
		self.reset_state_variables();
		self.armor_parts = [[],[],["/normal"]];
		//var _armors_to_load = [];
		array_foreach(_armors, function(_arm, _index){
			_arm = global.availible_characters[global.character_index].possible_armors[_index][_arm]
			
			if(typeof(_arm) != "struct" && _arm != noone){
				var _temp = {};
			
				with(_temp){
					script_execute(_arm)
				}
			
				_arm = _temp;
			} 
			//run any code and load it's directory
			if(typeof(_arm) == "struct"){
				var _can_cont = true;
				for(var g = 0; g < array_length(self.armor_parts[0]); g++){
					if(_arm.armor_name == self.armor_parts[0][g].armor_name)
						_can_cont = false;
				}
				
				if(_can_cont){
					//add the currently listed armor to the armor array
					array_push(self.armor_parts[0], _arm)
					var _directory_name = "/armor" + string(_arm.sprite_name)
					_directory_name = string_replace(_directory_name, "_", "/")
					//log(_directory_name);
					find("animation").add_subdirectories([_directory_name]);
					if(variable_struct_exists(_arm, "apply_armor_effects"))
						_arm.apply_armor_effects(self);
					
					if(variable_struct_exists(_arm, "damage_rate"))
						get(ComponentDamageable).damage_rate = _arm.damage_rate;
					
					if(variable_struct_exists(_arm, "buster_weapon")){
						global.availible_characters[global.character_index].weapons[0] = _arm.buster_weapon;
						get(ComponentWeaponUse).set_weapons(global.availible_characters[global.character_index].weapons);
					}
				
					array_push(self.armor_parts[2], _directory_name);
				
					//add the armor to the _armor_set array so we can set the armors in the animator
					var _armor_name = string(_arm.sprite_name);
					_armor_name = string_delete(_armor_name, 0, 1);
					_armor_name = string_replace(_armor_name, "/", "_");
					//log(_armor_name)
					array_push(self.armor_parts[1], _armor_name);
				}
			}
			
		});
		//publish the armor set
		self.publish("armor_set",self.armor_parts[1]);
		self.get_instance().components.get(ComponentAnimationShadered).set_subdirectories(self.armor_parts[2]);
		self.get_instance().components.get(ComponentAnimationShadered).reload_animations();
		//log(self.armor_parts[1])
		//log(self.armor_parts[2])
		//fix the armor_parts array. it does not need to store an array of strings
		self.armor_parts = self.armor_parts[0];
	}
	self.apply_armor_part = function(_armor){
		array_push(self.armor_parts, _armor)
		self.apply_full_armor_set(self.armor_parts);
	}
	
	self.remove_armor_part = function(_armor){
		array_delete(self.armor_parts, array_get_index(self.armor_parts, _armor), 1);
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
		if(!(paused || locked))
			self.default_step();
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
		
		array_foreach(self.armor_parts, function(_part) {
			if(typeof(_part) == "struct")
				if(_part.step_armor_effects != undefined)
					_part.step_armor_effects(self);
		})
		
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
			
		if !self.debug return;
		
		if(variable_struct_exists(self, "hdir"))
			draw_string(string(self.hdir), self.get_instance().x, self.get_instance().y - 32)
		if(variable_struct_exists(self, "vdir"))
			draw_string(string(self.vdir), self.get_instance().x, self.get_instance().y - 24)
		draw_string(string(self.physics.get_vspd()), self.get_instance().x + 16, self.get_instance().y - 24)
		draw_string(string(self.physics.get_hspd()), self.get_instance().x + 16, self.get_instance().y - 32)
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
	
	self.add_dash = function(){
		self.fsm.add("dash", {
			enter: function() {//
				WORLD.play_sound("dash");
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
				if(CURRENT_FRAME mod 8 == 0){
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
		.add_transition("t_dash_end", "dash", "fall", function() { return !self.physics.is_on_floor(self.ground_distance); })
		.add_transition("t_dash_end", "dash", "dash_end", function() { return self.physics.is_on_floor(self.ground_distance); })
		.add_wildcard_transition("t_dash", "dash", function() { return !self.physics.check_wall(self.dash_dir) && self.physics.is_on_floor(self.ground_distance) && !self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y - 2, obj_square_16); })
	}
	
	self.add_wall_jump = function(){
		self.fsm.add("wall_slide", {
			enter: function() {
				self.input.__useBuffer = true;
				self.timer = 0;
				self.publish("animation_play", { name: "wall_slide" });
				self.physics.set_speed(0, 0);
				self.physics.set_grav(new Vec2(0,0));
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
				WORLD.play_sound("jump");
				self.input.__useBuffer = false;
				self.timer = CURRENT_FRAME;
				self.publish("animation_play", { name: "wall_jump" });
				self.dir = self.get_wall_jump_dir();
				if (self.dir != 0) self.publish("animation_xscale", self.dir)
				self.physics.set_speed(0, 0);
				self.physics.set_grav(new Vec2(0,0));
				var _inst = self.get_instance();
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
					
					if (self.input.get_input("dash") && self.fsm.state_exists("dash")) {
						WORLD.spawn_particle(new LimeDieParticle(_inst.x + 16 * self.dir, _inst.y + 16, self.dir))
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
	
	self.add_melee_state = function(){
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

	self.add_aimable_state = function(){
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