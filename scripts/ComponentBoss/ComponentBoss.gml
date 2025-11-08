function ComponentBoss() : ComponentBase() constructor{
	self.identifier = "boss";
	
	self.has_done_dialouge = false;
	self.boss_data = new TestBoss();
	
	self.health_tick = false;
	
	self.dir = -1;//always presume they start off facing left. that's towards the player, usually
	
	self.death_time = -1;
	
	self.pose_animation_name = "walk";
	
	self.contact_damage = 3;
	
	self.desperate = false;//you dont start out desperate
	self.desperation_rate = 1/3;//how low the boss has to be in order to be desperate
	
	//self.serializer = new NET_Serializer();
	self.serializer
		.addCustom("fsm")
		.addVariable("desperation_rate")
	
	self.init = function(){
		//this has to be here. the game crashes otherwise
		self.publish("animation_play", { name: "idle" });
		self.publish("animation_xscale", -1);
	}
	
	self.fsm = new SnowState("enter", true);
	self.fsm
		.add("enter", {
			enter: function() {
				WORLD.stop_sound();
				WORLD.play_music("BossEncounterL");
				
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
			},
			step: function() {
				//im going to presume regular boss deaths. 
				
				if(CURRENT_FRAME mod 4 == 0 && CURRENT_FRAME - death_time < 371 && CURRENT_FRAME - death_time > 62){
					var _inst = self.get_instance();
					var _spot = new Vec2(_inst.x + (random_range(-32,32)),_inst.y + (random_range(-32,32)))
					
					WORLD.spawn_particle(new ExplosionParticle(_spot.x, _spot.y,1))
					if(CURRENT_FRAME mod 8 == 0)
					WORLD.play_sound("Explosion");
				}
				
				if(CURRENT_FRAME - death_time == 507){
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
		
		if(get(ComponentDamageable).health <= get(ComponentDamageable).health_max * self.desperation_rate && 
			self.fsm.get_current_state() != "enter" && self.fsm.get_current_state() != "pose"){
				self.desperate = true;
		}
		
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
