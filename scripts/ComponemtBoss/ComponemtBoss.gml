function ComponentBoss() : ComponentBase() constructor{
	
	log("i was made!")
	
	self.has_done_dialouge = false;
	self.boss_data = noone//for example purposes
	
	self.health_tick = false;
	
	self.dir = -1;//always presume they start off facing left. that's towards the player, usually
	
	log("variables made")
	
	self.init = function(){
		//this has to be here. the game crashes otherwise
		self.publish("animation_play", { name: "idle" });
	}
	
	log("init set up")
	
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
				self.publish("animation_play", { name: "walk" });
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
				WORLD.stop_sound();
				self.publish("animation_play", { name: "death" });
			},
			step: function() {
				//im going to presume regular boss deaths. 
				
				if(CURRENT_FRAME mod 4 == 0){
					var _cam = instance_nearest(0,0,obj_camera)
					WORLD.spawn_particle(new ExplosionParticle(_cam.x + random_range(0,GAME_W),_cam.y + random_range(0,GAME_H),1))
				}
			}
		})
	self.fsm.add_transition("t_transition", "enter", "pose", function(){return self.get_instance().components.get(ComponentPhysics).is_on_floor();})
		.add_transition("t_animation_end", "pose", "idle", function(){return self.get_instance().components.get(ComponentDamageable).health >= 32;})
		.add_wildcard_transition("t_transition", "die", function(){return self.fsm.get_current_state() != "die" && self.get(ComponentDamageable).health <= 0})
		
	log("fsm made")
	
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
	
	log("step made")
	
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
	
	log("on register made")
}
