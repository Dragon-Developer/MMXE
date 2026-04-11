function BassEXEBoss() : BaseBoss() constructor{
	switch(PLAYER_SPRITE){
		default:
		self.dialouge = [
			{   sentence : "Show yourself!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			},
			{   sentence : "Here I am!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			}
		];
		break;
		case("x"):
		self.dialouge = [
			{   sentence : "Please, come out! I'm willing to talk this out!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			},
			{   sentence : "There is nothing to discuss. I will prove that I am the STRONGEST!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "left"
			}
		];
		break;
		case("zero"):
		self.dialouge = [
			{   sentence : "I know a trap when I see one.",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			},
			{   sentence : "Good! You should be a good challenge, then!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "left"
			},
			{   sentence : "Well, when in rome.",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			}
		];
		break;
		case("axl"):
		self.dialouge = [
			{   sentence : "Hey! There's supposed to be a really strong maverick here! What gives?",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			},
			{   sentence : "Tch! I am much stronger than any maverick, BOY!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "left"
			},
			{   sentence : "Aight, prove it!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			}
		];
		break;
		case("megaman"):
		self.dialouge = [
			{   sentence : "Listen! I don't want to hurt you!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			},
			{   sentence : "What a waste, then! The other megamen I've battled were much more battle hungry!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "left"
			},
			{   sentence : "F-Fine! I'll show you how strong I am!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			}
		];
		break;
		case("bass"):
		self.dialouge = [
			{   sentence : "Tch! You think you're so good? Then why are you hiding, COWARD?",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			},
			{   sentence : "You think that yelling makes you look stronger, you DOLT!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "left"
			},
			{   sentence : "Ooh, ILL SHOW YOU WHO'S THE REAL DOLT!",
				mugshot_left : "exe",
				mugshot_right : PLAYER_SPRITE,
				focus : "right"
			}
		];
		break;
	}
	
	self.image_folder = "boss";
	self.subdirectories = ["/normal","/exe"];
	
	self.init = function(_par){
		//log("init?")
		_par.publish("animation_play", { name: "exe_idle" });
		_par.publish("has_dialouge", true);
	}
	
	
	self.pose_animation_name = "exe_laser";
	self.intro_animation_name = "exe_idle";
	self.death_animation_name = "exe_die";
	
	self.add_states = function(_player){
		
		with(_player){
			self.get(ComponentPhysics).set_grav(new Vec2(0,0));
			self.get(ComponentPhysics).set_vspd(0.75);
			self.pose_animation_name = other.pose_animation_name;
			self.intro_animation_name = other.intro_animation_name;
			self.death_animation_name = other.death_animation_name;
			self.timer = -1;
			self.has_dialouge = true;
			self.dialouge = other.dialouge
			self.desperate_rate = 1/3
			self.max_health = 32 * ((DIFF + 1) / 2)
			fsm.add("idle", { 
					enter: function(){
						self.get(ComponentPhysics).set_vspd(0);
						self.face_player();
						self.publish("animation_xscale", self.dir);
						self.publish("animation_play", { name: "exe_idle" });
					}
				})
			.add("dash", {
				enter: function(){
					self.publish("animation_play", { name: "exe_idle" });
					self.timer = CURRENT_FRAME
				},
				
				step: function(){
					self.face_player();
					var _inst = self.get_instance();
					with(_inst){
						var _point = instance_nearest(x, y, Boss_ref_node)
						move_towards_point(_point.x, _point.y, distance_to_object(_point) / 17)
					}
				},
				leave: function(){
					var _inst = self.get_instance();
					with(_inst){
						speed = 0;
					}
				}
			})
			.add("area_grab_startup", {
				enter: function(){
					self.publish("animation_play", { name: "exe_hand" });
					self.timer = CURRENT_FRAME
					self.dir *= -1;
					self.publish("animation_xscale", self.dir);
				},
				
				step: function(){
					var _inst = self.get_instance();
					if(CURRENT_FRAME - self.timer > (desperate ? 15 : 60)){
						_inst.x += dir * 0.5;
						with(_inst){
							speed = 0;
						}
					} else {
						with(_inst){
							var _point = instance_nearest(x, y, Boss_ref_node)
							move_towards_point(_point.x - 112 * other.dir, _point.y + 96, distance_to_point(_point.x - 112 * other.dir, _point.y + 96) / 6)
						}
					}
				},
				leave: function(){
					var _inst = self.get_instance();
					with(_inst){
						speed = 0;
					}
				}
			})
			.add("area_grab", {
				enter: function(){
					self.publish("animation_play", { name: "exe_grab" });
					self.timer = CURRENT_FRAME
				},
				
				step: function(){
					var _inst = self.get_instance();
					_inst.x += dir * 14
				},
				leave: function(){
					var _inst = self.get_instance();
					with(_inst){
						speed = 0;
					}
				}
			})
			.add("area_grab_slam", {
				enter: function(){
					self.publish("animation_play", { name: "exe_grab" });
					self.timer = CURRENT_FRAME
				},
				
				step: function(){
					var _inst = self.get_instance();
					if(CURRENT_FRAME - self.timer >= 30){
						_inst.y += 35
					} else {
						_inst.y -= 35
					}
					with(obj_player){
						x = other.get_instance().x + other.dir * 20;
						y = other.get_instance().y;
					}
				},
				leave: function(){
					var _inst = self.get_instance();
					with(_inst){
						speed = 0;
					}
					with(obj_player){
						components.get(ComponentDamageable).invuln_offset = -1
						components.get(ComponentDamageable).take_damage(other.desperate ? 2 : 4);
					}
					WORLD.play_sound("explosion");
				}
			})
			.add("panel_remove_startup", {
				enter: function(){
					self.publish("animation_play", { name: "exe_clamp" });
					self.timer = CURRENT_FRAME
					with(obj_player){
						if(omponents.get(ComponentDamageable).health > 0)
						components.get(ComponentPlayerMove).fsm.change("hurt")
					}
				},
				
				step: function(){
					var _inst = self.get_instance();
					with(_inst){
						var _point = instance_nearest(x, y, Boss_ref_node)
						move_towards_point(_point.x, _point.y, distance_to_object(_point) / 3)
					}
					if(CURRENT_FRAME - self.timer < 70){
						with(obj_player){
							var _point = instance_nearest(x, y, Boss_ref_node)
							move_towards_point(_point.x, y, distance_to_point(_point.x, y) / 14)
						}
					} else {
						with(obj_player){
							speed = 0;
						}
					}
					
					if(CURRENT_FRAME - self.timer == 20){
						var _cam_x = camera_get_view_x(view_get_camera(view_current));
						var _cam_y = camera_get_view_y(view_get_camera(view_current));
						instance_create_depth(_cam_x - 64, _cam_y, -400, obj_exe_walls);
					
						var _righty = instance_create_depth(_cam_x + GAME_W + 64, _cam_y, -400, obj_exe_walls);
						_righty.move_dir = -1;	
					}
				},
				leave: function(){
					var _inst = self.get_instance();
					with(_inst){
						speed = 0;
					}
					with(obj_player){
						speed = 0;
					}
				}
			})
			
			.add("panel_remove", {
				enter: function(){
					var _inst = self.get_instance();
					var _point = instance_nearest(_inst.x, _inst.y, Boss_ref_node)
					
					_inst.x = _point.x;
					_inst.y = _point.y;
					self.publish("animation_play", { name: "exe_hand" });
					self.timer = CURRENT_FRAME
					self.ball_speed = desperate ? 10 : 1
				},
				
				step: function(){
					ball_speed += (CURRENT_FRAME - self.timer) / (desperate ? 70 : 75)
					if CURRENT_FRAME mod 2 == 0 return;
					var _inst = self.get_instance();
					
					var _shot = PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXELaser, self, ["enemy"], 0);
					_shot.code.rotation = 180 + ball_speed * dir;
				},
				leave: function(){
					var _inst = self.get_instance();
					with(_inst){
						speed = 0;
					}
					with(obj_exe_walls){
						move_speed = -1;
						move_lerp = 1.1;
					}
				}
			})
			.add("crush_wheel", {
				enter: function(){
					self.publish("animation_play", { name: "exe_laser" });
					self.timer = CURRENT_FRAME
				}, 
				step: function(){
					
					var _inst = self.get_instance();
					with(_inst){
						var _point = instance_nearest(x, y, Boss_ref_node)
						move_towards_point(_point.x - 120 * other.dir, _point.y - 64, distance_to_point(_point.x - 120 * other.dir, _point.y - 64) / 10)
					}
					
					if(desperate) {
						if(CURRENT_FRAME - self.timer == 40){
							PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXEBallFloor, self, ["enemy"], 0);
							PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXEBallRoof, self, ["enemy"], 0);
						} else if(CURRENT_FRAME - self.timer == 50){
							PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXEBallFloor, self, ["enemy"], 0);
							PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXEBallRoof, self, ["enemy"], 0);
						} else if(CURRENT_FRAME - self.timer == 60){
							PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXEBallFloor, self, ["enemy"], 0);
							PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXEBallRoof, self, ["enemy"], 0);
						}
					} else {
						if(CURRENT_FRAME - self.timer == 40){
							PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXEBallFloor, self, ["enemy"], 0);
						} else if(CURRENT_FRAME - self.timer == 70){
							PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXEBallRoof, self, ["enemy"], 0);
						}
					}
				}
			})
			.add("antivirus", {
				enter: function(){
					self.publish("animation_play", { name: "exe_shoot" });
					self.timer = CURRENT_FRAME
				}, 
				step: function(){
					
					var _inst = self.get_instance();
					
					
					if(desperate){
						if(CURRENT_FRAME - self.timer >= 55 && CURRENT_FRAME mod 2 == 0){
							var _shot = PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXELaser, self, ["enemy"], 0);
							_shot.code.rotation = (CURRENT_FRAME - self.timer - 55) * -3 * dir
						} else if(CURRENT_FRAME - self.timer >= 30){
							if CURRENT_FRAME mod 2 == 0 
								PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXELaser, self, ["enemy"], 0);
							_inst.x += dir * 5.9
							_inst.speed = 0;
						} else {
							with(_inst){
								var _point = instance_nearest(x, y, Boss_ref_node)
								move_towards_point(_point.x - 88 * other.dir, _point.y, distance_to_point(_point.x - 88 * other.dir, _point.y) / 10)
							}
						}	
					} else {
						if(CURRENT_FRAME - self.timer >= 90 && CURRENT_FRAME mod 2 == 0){
							var _shot = PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXELaser, self, ["enemy"], 0);
							_shot.code.rotation = (CURRENT_FRAME - self.timer - 90) * -3 * dir
						} else if(CURRENT_FRAME - self.timer >= 80 && CURRENT_FRAME mod 2 == 0){
							PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXELaser, self, ["enemy"], 0);
						} else if(CURRENT_FRAME - self.timer >= 30){
							if CURRENT_FRAME mod 2 == 0 
								PROJECTILES.create_projectile(_inst.x, _inst.y, dir, EXELaser, self, ["enemy"], 0);
							_inst.x += dir * 2.9
							_inst.speed = 0;
						} else {
							with(_inst){
								var _point = instance_nearest(x, y, Boss_ref_node)
								move_towards_point(_point.x - 88 * other.dir, _point.y, distance_to_point(_point.x - 88 * other.dir, _point.y) / 10)
							}
						}	
					}
				}
			})
			.add_transition("t_animation_end", "idle", "dash")
			.add_transition("t_transition", "crush_wheel", "antivirus", function(){return CURRENT_FRAME - self.timer > (desperate ? 95 : 90)})
			.add_transition("t_transition", "antivirus", "area_grab_startup", function(){return CURRENT_FRAME - self.timer > (desperate ? 85 : 120) && random_value < 60})
			.add_transition("t_transition", "antivirus", "panel_remove_startup", function(){return CURRENT_FRAME - self.timer > (desperate ? 85 : 120) && random_value >= 60})
			.add_transition("t_transition", "panel_remove_startup", "panel_remove", function(){return CURRENT_FRAME - self.timer > 90 })
			.add_transition("t_transition", "panel_remove", "area_grab_startup", function(){return CURRENT_FRAME - self.timer > 300 })
			.add_transition("t_transition", "area_grab_startup", "area_grab", function(){return CURRENT_FRAME - self.timer > (desperate ? 35 : 80) })
			.add_transition("t_transition", "area_grab", "dash", function(){return CURRENT_FRAME - self.timer > 20 })
			.add_transition("t_transition", "area_grab_slam", "dash", function(){return CURRENT_FRAME - self.timer > 59 })
			.add_transition("t_transition", ["area_grab", "area_grab_startup"], "area_grab_slam", function(){return instance_position(self.get_instance().x, self.get_instance().y, obj_player) || instance_position(self.get_instance().x + dir * 6, self.get_instance().y, obj_player) })
			.add_transition("t_transition", "dash", "crush_wheel", function(){return CURRENT_FRAME - self.timer > (desperate ? 150 : 100)})
		}
	}
}