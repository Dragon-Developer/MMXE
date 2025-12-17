function ComponentBoss() : ComponentBase() constructor{
	
	self.has_done_dialouge = false;
	self.boss_data = noone//for example purposes
	
	self.health_tick = false;
	
	self.dir = -1;//always presume they start off facing left. that's towards the player, usually
	
	self.death_time = -1;
	self.contact_damage = 2;
	
	self.pose_animation_name = "walk";
	self.intro_animation_name = "blade_fall";
	
	self.init = function(){
		//this has to be here. the game crashes otherwise
		self.publish("animation_play", { name: self.intro_animation_name });
		self.publish("animation_xscale", -1);
		
		//self.boss_data.init(self);
	}
	
	self.fsm = new SnowState("enter", true);
	self.fsm
		.add("enter", {
			enter: function() {
				WORLD.stop_sound();
				WORLD.play_music("BossEncounterL");
				self.publish("animation_play", { name: self.intro_animation_name });
			},
			step: function() {
				//log("step")
			}
		})
		.add("pose", {
			enter: function() {
				self.publish("animation_play", { name: self.pose_animation_name });
				self.get_instance().components.add([ComponentHealthbar]);
				self.get_instance().components.get(ComponentHealthbar).init();
				self.get_instance().components.get(ComponentHealthbar).barOffsets[0] = new Vec2(GAME_W - 24,78)
				self.get_instance().components.get(ComponentDamageable).health_max = 32;
				self.get_instance().components.get(ComponentDamageable).health = 1;
			},
			step: function() {
				//if the pose animation is finished, then make the healthbar,
				// fill it, then move to idle and free the player
				
				if(self.health_tick){
					if(self.get_instance().components.get(ComponentDamageable).health < self.get_instance().components.get(ComponentDamageable).health_max)
						self.get_instance().components.get(ComponentDamageable).health++;
					self.health_tick = false;
				} else {
					self.health_tick = true;
					//log("tick")
				}
			},
			leave: function(){
				with(instance_nearest(self.get_instance().x, self.get_instance().y, obj_player)){
					components.get(ComponentPlayerInput).__locked = false;
				}
				WORLD.stop_sound();
				WORLD.play_music("BossBattleL");
			}
		})
		.add("die", {
			enter: function() {
				with(instance_nearest(self.get_instance().x, self.get_instance().y, obj_player)){
					components.get(ComponentPlayerInput).__locked = true;
				}
				WORLD.clear_sound();
				self.publish("animation_play", { name: "death" });
				self.death_time = CURRENT_FRAME;
				
				GAME.game_loop.do_action_with_all_components(function(){step_enabled = false;})
				step_enabled = true;
				with(obj_player){
					components.find("animation").animation.__speed = 0;
					components.get(ComponentPhysics).set_grav(new Vec2(0,0));
					components.get(ComponentPhysics).set_speed(0,0)
				}
			},
			step: function() {
				//im going to presume regular boss deaths. 
				
				var _time = CURRENT_FRAME - death_time;
				
				if(_time == 59){
					GAME.game_loop.do_action_with_all_components(function(){step_enabled = true;})
					with(obj_player){
						components.find("animation").animation.__speed = 1;
						components.get(ComponentPhysics).set_grav(new Vec2(0,0.25));
					}
				}
				
				if(_time == 192){
					var _fade = instance_create_depth(get_instance().x,get_instance().y,0,obj_fade);
					_fade.transition_fade(120)
					_fade.transition_data.sprite = spr_bright;
					_fade.transition_data.wait_time = 161;
				}
				
				if (_time >= 193 && _time <= 253) {
					var _ind = 1 - ((_time - 193) / 60 * 255);
					
					var _col = make_color_rgb(_ind, _ind, _ind)
					
					find("animation").animation.__color = _col;
				}
				
				if(_time >= 345 && _time <= 365){
					find("animation").animation.__alpha = 1 - (_time - 345) / 20;
				}
				
				if(CURRENT_FRAME mod 4 == 0 && _time < 371 && _time > 62){
					var _inst = self.get_instance();
					var _range = 30;
					var _spot = new Vec2(_inst.x + (random_range(-_range,_range)),_inst.y + (random_range(-_range,_range)))
					
					WORLD.spawn_particle(new ExplosionParticle(_spot.x, _spot.y,1))
					
					if(CURRENT_FRAME mod 8 == 0)
						WORLD.play_sound("Explosion");
				}
				
				if(_time == 507){
					WORLD.clear_sound();
					with(obj_player){
						components.publish("complete");
					}
				}
				
				
			}
		})
	self.fsm.add_transition("t_transition", "enter", "pose", function(){return self.get_instance().components.get(ComponentPhysics).is_on_floor();})
		.add_transition("t_animation_end", "pose", "idle", function(){return self.get_instance().components.get(ComponentDamageable).health >= 32;})
		.add_wildcard_transition("t_transition", "die", function(){return self.fsm.get_current_state() != "die" && self.get(ComponentDamageable).health <= 0})
		
	
	self.step = function() {
		try {
			self.fsm.trigger("t_transition");
		} catch(_err){
			log(_err)
		}
	
		if (self.fsm.event_exists("step")){
			self.fsm.step();
			
		}
	}
	
	self.on_register = function() {
		self.subscribe("animation_end", function() {
			//do something. will probably add functionality later.	
		});
		self.subscribe("enemy_data_set", function(_dir){
			boss_data = _dir;
			log("step 1")
			EnemyEnum = new boss_data();
			log("step 2")
			EnemyEnum.setComponent(self);
			log("step 3")
			EnemyEnum.init(self.get_instance());
			log("step 4")
			
		});
		self.subscribe("animation_end", function() {
			self.fsm.trigger("t_animation_end");	
		});
	}
	
	self.draw_gui = function(){
		
		
	}
	
	self.face_player = function(){
		var _inst = self.get_instance();
		if(instance_nearest(_inst.x, _inst.y, obj_player).x > _inst.x)
			self.dir = 1;
		else 
			self.dir = -1;
	}
}
