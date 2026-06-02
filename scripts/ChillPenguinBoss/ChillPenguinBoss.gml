function ChillPenguinBoss() : BaseBoss() constructor{
	self.dialouge = [
		{   sentence : "Tch! You hunters pushed me so far out of the mountains! Do you know how hot it is here?",
			mugshot_left : "chill_penguin",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "How about this?.",
			mugshot_left : "chill_penguin",
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		},
		{   sentence : "You surrender, and I get you a nice and cold room for rehab.",
			mugshot_left : "chill_penguin_angry",
			mugshot_right : PLAYER_SPRITE,
			focus : "right",
			additive: true
		},
		{   sentence : "Like HELL I'm going back to there, " + PLAYER_SPRITE + "!",
			mugshot_left : "chill_penguin_angry",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "How about I just kill you!",
			mugshot_left : "chill_penguin",
			mugshot_right : PLAYER_SPRITE + "_angry",
			focus : "left",
			additive: true
		}
	];
	
	self.image_folder = "boss";
	self.subdirectories = ["/normal","/chill"];
	
	self.init = function(_par){
		//log("init?")
		_par.publish("animation_play", { name: "exe_idle" });
		_par.publish("has_dialouge", true);
	}
	
	
	self.pose_animation_name = "chill_pose";
	self.intro_animation_name = "chill_fall";
	self.death_animation_name = "chill_damage";
	self.dialouge_animation_name = "chill_idle";
	
	/*
		Chill states
		- idle goofing around
		- jump
		- go to ring
		- blow wind on ring
		- belly slide
		- ice breath
		- puke icicles
	*/
	
	self.add_states = function(_player){
		
		with(_player){
			self.pose_animation_name = other.pose_animation_name;
			self.intro_animation_name = other.intro_animation_name;
			self.death_animation_name = other.death_animation_name;
			self.dialouge_animation_name = other.dialouge_animation_name;
			self.timer = -1;
			self.get(ComponentDamageable).weaknesses = [{projectile: FireWaveData, rate: 8}, {projectile: FireWaveTempFullCharge, rate: 3}]
			self.has_dialouge = true;
			self.dialouge = other.dialouge
			self.desperate_rate = 1/3
			self.max_health = 32 * ((DIFF + 1) / 2)
			self.contact_damage = 3
			
			self.on_weakness = function(){
				fsm.change("damaged")
			}
			
			fsm.add("idle", { 
					enter: function(){
						self.get(ComponentPhysics).set_speed(0, 0);
						self.face_player();
						self.publish("animation_xscale", self.dir);
						self.publish("animation_play", { name: "chill_idle" });
						self.timer = CURRENT_FRAME + 50 / ((DIFF + 1) / 2);
						var _point = instance_nearest(0, 0, Boss_ref_node)
						var _inst = self.get_instance();
					
						_inst.y = _point.y + 10 * 16
					},
					step: function(){
						self.face_player();
						self.publish("animation_xscale", self.dir);
					}
				})
			.add("belly_slide_startup", {
				enter: function(){
					self.publish("animation_play", { name: "chill_slide" });
					self.timer = CURRENT_FRAME + 40;
				},
				step: function(){
				},
				leave: function(){
				}
			})
			.add("belly_slide", {
				enter: function(){
					self.timer = 8 + DIFF + random_value * 0.01
				},
				step: function(){
					
					var _inst = self.get_instance();
					
					_inst.x += self.timer * self.dir
					self.timer -= 0.1;
					self.publish("animation_xscale", self.dir);
					
					self.get(ComponentDamageable).invuln_offset = CURRENT_FRAME + 2;
					
					if(instance_position(_inst.x + 1 / (CURRENT_FRAME - self.timer) * self.dir, _inst.y, obj_square_16))
						dir *= -1;
				},
				leave: function(){
				}
			})
			.add("jump", {
				enter: function(){
					self.publish("animation_play", { name: "chill_jump" });
					self.timer = CURRENT_FRAME
					if fsm.get_previous_state() == "wind" return;
					self.get(ComponentPhysics).set_speed(6 * dir, -9);
					var _inst = self.get_instance();
					_inst.y -= 6
				},
				step: function(){
					var _inst = self.get_instance();
					if(instance_position(_inst.x + 16 * self.dir, _inst.y, obj_square_16)){
						self.get(ComponentPhysics).set_hspd(-0.1 * dir);
					}
					
					if self.get(ComponentPhysics).get_vspd() == 0{
						self.publish("animation_play", { name: "chill_fall" });
					}
					
					if self.get(ComponentPhysics).get_vspd() == 3.5{
						self.dir *= -1;
						self.publish("animation_xscale", self.dir);
						PROJECTILES.create_projectile(_inst.x + dir * 25, _inst.y, dir, EvilShotgunIce, self, ["enemy"], 0);
					}
					
					if self.get(ComponentPhysics).get_vspd() == 5.5{
						PROJECTILES.create_projectile(_inst.x + dir * 25, _inst.y, dir, EvilShotgunIce, self, ["enemy"], 0);
					}
				},
				leave: function(){
				}
			})
			.add("wind_end", {
				enter: function(){
					self.publish("animation_play", { name: "chill_jump" });
					self.timer = CURRENT_FRAME
					self.get(ComponentPhysics).set_speed(0, 0);
				},
				step: function(){
				},
				leave: function(){
				}
			})
			.add("wind_startup", {
				enter: function(){
					self.publish("animation_play", { name: "chill_jump" });
					self.timer = CURRENT_FRAME + 40;
					
					var _point = instance_nearest(0, 0, Boss_ref_node)
					
					var _diff = _point.x - self.get_instance().x;
					self.get_instance().y -= 6
					
					self.get(ComponentPhysics).set_speed(_diff / 40, -9);
				},
				step: function(){
				},
				leave: function(){
				}
			})
			.add("wind", {
				enter: function(){
					self.get(ComponentPhysics).set_grav(new Vec2(0,0));
					self.get(ComponentPhysics).set_speed(0, 0);
					self.publish("animation_play", { name: "chill_grab" });
					self.timer = CURRENT_FRAME + 100 - clamp((self.get(ComponentDamageable).health_max - self.get(ComponentDamageable).health) * 2, 0, 80);
					var _point = instance_nearest(0, 0, Boss_ref_node)
					var _inst = self.get_instance();
					
					_inst.y = _point.y 
					
					var _wind = instance_create_depth(_point.x, _point.y, -1500, wind_handler)
					_wind.dir = (floor(random_value) mod 2) * 2 - 1
				},
				step: function(){
				},
				leave: function(){
					self.get(ComponentPhysics).set_grav(new Vec2(0,0.25));
				}
			})
			.add("spawn_statues_startup", {
				enter: function(){
					self.publish("animation_play", { name: "chill_statue_startup" });
					self.timer = CURRENT_FRAME + 50 / ((DIFF + 1) / 2);
				},
				step: function(){
				},
				leave: function(){
				}
			})
			.add("spawn_statues", {
				enter: function(){
					self.publish("animation_play", { name: "chill_statue_hold" });
					self.timer = CURRENT_FRAME + 200 * DIFF / 2
					var _inst = self.get_instance();
					
					ENEMIES.create_enemy(_inst.x + dir * 40, _inst.y, dir, ChillStatue)
					
					ENEMIES.create_enemy(_inst.x + dir * 80, _inst.y, dir, ChillStatue)
				},
				step: function(){
					if CURRENT_FRAME mod 3 == 0 return;
					var _inst = self.get_instance();
					if CURRENT_FRAME mod 3 == 1 
					var _shot = PROJECTILES.create_projectile(_inst.x + dir * 25, _inst.y, dir, ChillPenguinHalitosis, self, ["enemy"], 0);
					else
					var _shot = PROJECTILES.create_projectile(_inst.x + dir * 25, _inst.y, dir, ChillPenguinHalitosis2, self, ["enemy"], 0);
				},
				leave: function(){
				}
			})
			.add("puke", {
				enter: function(){
					self.publish("animation_play", { name: "chill_puke" });
					self.timer = CURRENT_FRAME + ((floor(random_value) mod 3) + 2 + DIFF) * 60
					self.timer2 = CURRENT_FRAME - 4
				},
				step: function(){
					var _inst = self.get_instance();
					var _plr = instance_nearest(_inst.x,_inst.y,obj_player)
					if(sign(_plr.x - _inst.x) != dir){
						dir *= -1;
						var _shot = PROJECTILES.create_projectile(_inst.x + dir * 25, _inst.y, dir, EvilShotgunIce, self, ["enemy"], 0);
						
					}
					
					if (CURRENT_FRAME - self.timer2) mod 60 != 0 return;
					
					var _proj = floor(random_value) mod 2 == 0 ? ChillPuke90Degree : ChillPuke30Degree
					var _shot = PROJECTILES.create_projectile(_inst.x + dir * 25, _inst.y, dir, _proj, self, ["enemy"], 0);
				},
				leave: function(){
				}
			})
			.add("damaged", {
				enter: function(){
					self.publish("animation_play", { name: "chill_oh_fuck" });
					self.timer = CURRENT_FRAME + 50;
				},
				step: function(){
				},
				leave: function(){
				}
			})
			.add_transition("t_transition", "idle", "belly_slide_startup", function(){return CURRENT_FRAME > self.timer && floor(random_value) mod 5 == 0})
			.add_transition("t_transition", "idle", "puke", function(){return CURRENT_FRAME > self.timer && floor(random_value) mod 5 == 1})
			.add_transition("t_transition", "idle", "spawn_statues_startup", function(){return CURRENT_FRAME > self.timer && floor(random_value) mod 5 == 2})
			.add_transition("t_transition", "idle", "wind_startup", function(){return CURRENT_FRAME > self.timer && floor(random_value) mod 5 == 3 && desperate})
			.add_transition("t_transition", "idle", "jump", function(){return CURRENT_FRAME > self.timer && floor(random_value) mod 5 == 4})
			.add_transition("t_transition", "belly_slide_startup", "belly_slide", function(){return CURRENT_FRAME > self.timer})
			.add_transition("t_transition", "wind_startup", "wind", function(){return CURRENT_FRAME > self.timer})
			.add_transition("t_transition", "spawn_statues", "idle", function(){return CURRENT_FRAME > self.timer})
			.add_transition("t_transition", "wind", "wind_end", function(){return CURRENT_FRAME > self.timer})
			.add_transition("t_transition", "spawn_statues_startup", "spawn_statues", function(){return CURRENT_FRAME > self.timer})
			.add_transition("t_transition", "puke", "idle", function(){return CURRENT_FRAME > self.timer})
			.add_transition("t_transition", "damaged", "idle", function(){return CURRENT_FRAME > self.timer})
			.add_transition("t_transition", "belly_slide", "idle", function(){return self.timer < 0})
			.add_transition("t_transition", ["jump", "wind_end"], "idle", function()
				{return instance_position(self.get_instance().x, self.get_instance().y + 24, obj_square_16)})
		}
	}
}

function EvilShotgunIce() : ShotgunIceData() constructor{
	self.animation = "chill_nuke";
	self.strength = 0.95
}

function ChillPenguinHalitosis() : FlamethrowerData() constructor{
	self.comboiness = 1;//one full volley of lemons
	
	self.shot_limit = 20;
	self.shot_delay = 3;
	self.damage = 0;
	self.boss_damage = 2;
	self.animation = "chill_breath_1";
	self.init_time = CURRENT_FRAME;
	self.spd = 8;
	self.life = 10;
	
	self.create = function(_inst){
		//WORLD.play_sound("fire_wave");
	}
	self.step = function(_inst){
		var _hspd = spd;
			_inst.x += _hspd * self.dir;
			
			if(CURRENT_FRAME > init_time + life)
				PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
				
				if(instance_position(_inst.x + dir * 10, _inst.y, obj_player)){
					var _plr = instance_position(_inst.x + dir * 10, _inst.y, obj_player)
					
					if(_plr.components.get(ComponentPlayerMove).fsm.get_current_state() == "frozen") return;
					
					if!(_plr.components.get(ComponentPlayerMove).fsm.state_exists("frozen")){
						
						with(_plr.components.get(ComponentPlayerMove)){
							fsm.add("frozen", {
								enter: function(){
									self.publish("animation_play", { name: "idle" });
									self.timer = CURRENT_FRAME + 800;
									self.physics.set_speed(0,0)
								},
								step: function(){
									if(input.get_input("jump") || input.get_input("dash") || input.get_input("shoot") || input.get_input("shoot2") || input.get_input("up") || input.get_input("left") || input.get_input("right") || input.get_input("down")){
										self.timer -= 15;
									}
								},
								leave: function(){
								},
								draw: function(){
									var _inst = self.get_instance();
									find("animation").draw_action("frozen", undefined, 0, _inst.x, _inst.y)
								}
							})
							.add_transition("t_transition", "frozen", "idle", function(){return CURRENT_FRAME > self.timer})
						}
					}
					
					_plr.components.get(ComponentPlayerMove).fsm.change("frozen")
				}
	}
	self.destroy = function(_inst){
		//WORLD.spawn_particle(new FireWaveDieParticle(_inst.x, _inst.y, dir))
	}
}

function ChillPenguinHalitosis2() : ChillPenguinHalitosis() constructor{
	
	self.animation = "chill_breath_2";
	self.spd = 5;
	self.life = 16;
}

function ChillPuke90Degree() : ProjectileData() constructor{
	
	self.animation = "chill_puke_90";
	self.spd = 4 + DIFF
	
	self.angles = [new Vec2(5, 0), new Vec2(0, 5)]
	
	self.create = function(_inst){
		//WORLD.play_sound("fire_wave");
	}
	self.step = function(_inst){
		var _hspd = spd;
			_inst.x += _hspd * self.dir;
			
			if(instance_position(_inst.x + 6 * dir, _inst.y, obj_square_16)){
				PROJECTILES.create_projectile(_inst.x, _inst.y, dir, ChillNeedleFlat, self, ["enemy"], 0);
				PROJECTILES.create_projectile(_inst.x, _inst.y, dir, ChillNeedleVertical, self, ["enemy"], 0);
				PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
			}
	}
	self.destroy = function(_inst){
		//WORLD.spawn_particle(new FireWaveDieParticle(_inst.x, _inst.y, dir))
	}
}

function ChillPuke30Degree() : ProjectileData() constructor{
	
	self.animation = "chill_puke_30";
	self.spd = 4 + DIFF
	
	self.angles = [new Vec2(5, 0), new Vec2(0, 5)]
	
	self.create = function(_inst){
		//WORLD.play_sound("fire_wave");
	}
	self.step = function(_inst){
		var _hspd = spd;
			_inst.x += _hspd * self.dir;
			
			if(instance_position(_inst.x + 6 * dir, _inst.y, obj_square_16)){
				PROJECTILES.create_projectile(_inst.x, _inst.y, dir, ChillNeedle30Down, self, ["enemy"], 0);
				PROJECTILES.create_projectile(_inst.x, _inst.y, dir, ChillNeedle60Down, self, ["enemy"], 0);
				PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
			}
	}
	self.destroy = function(_inst){
		//WORLD.spawn_particle(new FireWaveDieParticle(_inst.x, _inst.y, dir))
	}
}

function ChillNeedleFlat() : ProjectileData() constructor{
	self.turn = new Vec2(-5, 0)
	self.animation = "shotgun_ice_fragment";
	self.create = function(_inst){
		//WORLD.play_sound("fire_wave");
	}
	self.step = function(_inst){
		_inst.x += turn.x * dir;
		_inst.y += turn.y;
	}
	self.destroy = function(_inst){
		//WORLD.spawn_particle(new FireWaveDieParticle(_inst.x, _inst.y, dir))
	}
}

function ChillNeedleVertical() : ChillNeedleFlat() constructor{
	self.turn = new Vec2(0, -5)
}

function ChillNeedle30() : ChillNeedleFlat() constructor{
	self.turn = turn.rotate(-30)
}

function ChillNeedle60() : ChillNeedleFlat() constructor{
	self.turn = turn.rotate(-60)
}

function ChillNeedle30Down() : ChillNeedleFlat() constructor{
	self.turn = turn.rotate(30)
}

function ChillNeedle60Down() : ChillNeedleFlat() constructor{
	self.turn = turn.rotate(60)
}

function ChillStatue() : BaseEnemy() constructor{
	
	self.health = 3;
	
	self.sprite = "chill_statue"
	
	self.hitbox_scale = new Vec2(32,48);
	self.hitbox_offset = new Vec2(0,0);
	self.vspd = 0
	self.grav = 0.2
	
	self.create = function(_inst){
		collision = instance_create_depth(floor(_inst.x) - 2 + ((dir - 1) / 2) * 28, floor(_inst.y) - 8, 0, obj_square_16)
		collision.image_yscale = 2;
	}
	self.step = function(_inst){
		//movement code go here
		
		if(CURRENT_FRAME - start_time < 20 || !instance_exists(collision)) return;
		
		if(instance_position(_inst.x - 2, _inst.y + 8, obj_square_16)){
			while(instance_position(_inst.x - 2, _inst.y + 7, obj_square_16) && instance_position(_inst.x, _inst.y + 8, obj_square_16) != collision){
				_inst.y--;
				collision.y--;
			}
			vspd = 0;
		} else if(instance_position(_inst.x + 22, _inst.y + 8, obj_square_16)){
			while(instance_position(_inst.x + 22, _inst.y + 7, obj_square_16) && instance_position(_inst.x, _inst.y + 8, obj_square_16) != collision){
				_inst.y--;
				collision.y--;
			}
			vspd = 0;
		} else {
			vspd = clamp(vspd + grav, 0, 3);
			_inst.y += vspd;
		}
		
		if(instance_position(_inst.x, _inst.y, par_boss)){
			_inst.y -= 10000;
		}
		
		if(!instance_exists(collision)) return;
		
		collision.x = floor(_inst.x);
		collision.y = floor(_inst.y);
	}
}