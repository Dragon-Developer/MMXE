function TestBoss() : BaseBoss() constructor{
	self.dialouge = [
		{   sentence : "Youre a mean one Mr. Grinch",
			mugshot_left : X_Mugshot_Happy1,
			mugshot_right : X_Mugshot1,
			focus : "left"
		}
	];
	
	self.image_folder = "boss";
	self.subdirectories = ["/normal","/x"];
	
	self.pal = [
		#181818,
		#313131,
		#53524d,
		#7b5405,
		#ac940e,
		#f1e22d,
		#9b47f7
	]
	
	self.default_palette = [
		#203080,//Blue Armor Bits
		#0040f0,
		#0080f8,
		#1858b0,//Under Armor Teal Bits
		#50a0f0,
		#78d8f0,
		#f04010
	];
	
	self.init = function(_par){
		//log("init?")
		_par.publish("animation_play", { name: "fall" });
		
		for(var i = 0; i < array_length(pal); i++){
			_par.find("animation").set_palette_color(i, pal[i]);
		}
		
		for(var i = 0; i < array_length(self.default_palette); i++){
			_par.find("animation").set_base_color(i, self.default_palette[i]);
		}
		
		//log("initiate dammit")
	}
	
	self.add_states = function(_player){
		
		with(_player){
			self.get(ComponentPhysics).set_grav(new Vec2(0,0.25));
			self.pose_animation_name = "mach_hold";
			self.intro_animation_name = "mach_hold";
			self.attack_states = ["dash", "walkdown"]
			self.timer = -1;
			fsm.add("idle", { 
					enter: function(){
						self.face_player();
						self.publish("animation_xscale", self.dir);
						self.publish("animation_play", { name: "idle" });
						
						var _rand = random_range(0,array_length(self.attack_states));
						
						if(random_range(0,2) <= 1 && desperate){
							self.fsm.change("desperate_jump");
							return;
						}
						
						self.fsm.change(self.attack_states[_rand]);
						if(self.get_instance().components.get(ComponentPhysics).check_place_meeting(self.get_instance().x + self.dir * 12, self.get_instance().y, obj_square_16))
							self.fsm.change("jump")
					}
				})
			.add("dash", {
				enter: function(){
					self.publish("animation_play", { name: "dash" });
					self.get(ComponentPhysics).set_hspd(3.25 * self.dir)
				}, 
				step: function(){
					//self.get_instance().x += self.dir * 3.25;
				},
				leave: function(){
					self.get(ComponentPhysics).set_hspd(0)
				}
			})
			.add("jump",{
				enter: function(){
					self.publish("animation_play", { name: "jump" });
					if(self.get(ComponentPhysics).is_on_floor())
						self.get(ComponentPhysics).set_vspd(-5);
					self.get(ComponentPhysics).set_hspd(self.dir)
					//self.get(ComponentPhysics).set_grav(0.5)
				}
			})
			.add_child("jump", "wall_jump", {
				enter: function(){
					if(self.get(ComponentPhysics).is_on_ceil())
						self.dir = self.dir * -1;
					
					self.publish("animation_play", { name: "jump", frame: 10, reset: false});
					self.get(ComponentPhysics).set_hspd(self.dir)
				}
			})
			.add("wall_slide",{
				enter: function(){
					self.publish("animation_play", { name: "wall_jump" });
					self.get(ComponentPhysics).set_speed(0, 0);
					self.get(ComponentPhysics).set_grav(new Vec2(0, 0));
					self.timer = CURRENT_FRAME;
				},
				step: function(){
					if (self.timer + 11 < CURRENT_FRAME){
						self.fsm.change("wall_jump")
					} else if (self.timer + 7 < CURRENT_FRAME) {
						self.publish("animation_play_at_loop", { name: "jump", frame: 10});
					}
					if (self.timer + 5 == CURRENT_FRAME) {
						self.get(ComponentPhysics).update_gravity();
						if (!self.get(ComponentPhysics).is_on_ceil())
							self.get(ComponentPhysics).set_hspd(self.dir * -1)
						self.get(ComponentPhysics).set_vspd(-4);	
					}
				},
				leave: function(){
					self.get(ComponentPhysics).set_grav(new Vec2(0, 0.25));
				}
			})
			.add("fall",{
				enter: function(){
					self.publish("animation_play", { name: "fall" });
				},
				leave: function(){
					self.get(ComponentPhysics).set_vspd(0);
					self.get(ComponentPhysics).set_hspd(0)
				}
			})
			.add("walkdown", {
				enter: function(){
					self.publish("animation_play", { name: "walk" });
						self.get(ComponentPhysics).set_hspd(2 * self.dir)
				},
				leave: function(){
					self.get(ComponentPhysics).set_hspd(0)
				}
			})
			.add("desperate_dash", {
				enter: function(){
					self.publish("animation_play", { name: "flame_dash" });
					self.get(ComponentPhysics).set_hspd(8 * self.dir)
					self.get(ComponentPhysics).set_vspd(-2);
					self.get(ComponentPhysics).set_grav(new Vec2(0,0));
				}, 
				step: function(){
					get(ComponentDamageable).invuln_offset = CURRENT_FRAME + 1;
				},
				leave: function(){
					self.get(ComponentPhysics).set_hspd(0)
					self.get(ComponentPhysics).set_grav(new Vec2(0,0.25));
					get(ComponentDamageable).invuln_offset = -1;
				}
			})
			.add("desperate_jump",{
				enter: function(){
					self.publish("animation_play", { name: "quick_giga" });
				}, 
				step: function(){
					get(ComponentDamageable).invuln_offset = CURRENT_FRAME + 1;
				}
			})
			.add_transition("t_transition", ["dash", "walkdown", "desperate_dash"], "idle", function()
				{return self.get_instance().components.get(ComponentPhysics).check_place_meeting(self.get_instance().x + self.dir * 12, self.get_instance().y, obj_square_16)
			})
			.add_transition("t_transition", ["fall", "jump"], "idle", function()
				{return self.get_instance().components.get(ComponentPhysics).is_on_floor()
			})
			.add_transition("t_transition", ["dash", "walkdown"], "fall", function()
				{return self.get(ComponentPhysics).get_vspd() > 0
			})
			.add_transition("t_transition", "jump", "fall", function()
				{return self.get(ComponentPhysics).get_vspd() > 0 && !self.get_instance().components.get(ComponentPhysics).check_place_meeting(self.get_instance().x + self.dir * 12, self.get_instance().y, obj_square_16)
			})
			.add_transition("t_transition", "jump", "wall_slide", function()
				{return self.get(ComponentPhysics).get_vspd() > 0 && self.get_instance().components.get(ComponentPhysics).check_place_meeting(self.get_instance().x + self.dir * 12, self.get_instance().y, obj_square_16)
			})
			.add_transition("t_animation_end", "desperate_jump", "desperate_dash")
		}
	}
}