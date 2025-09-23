function ComponentDoor() : ComponentBase() constructor{
	
	/*
		this whole things is jank incarnate. it works the way i want it to though!
	*/
	
	time_delay = 45;
	time_offset = -1;
	activated = false;
	state_segment = -1;// 1 is opening door, 2 is moving player through door, 3 is closing door, and -1 means the door is shut
	multidirectional = false;//if its monodirectional, check the x scale
	curr_player = noone;
	curr_cam = noone;
	camera_total_movement = GAME_W;
	animation_end = false;
	physics = noone;
	flipped = false;
	spawn_boss = true;
	
	prev_cam_x = -1;

	coll = noone;
	
	self.serializer.addVariable("activated")
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
		});
		self.subscribe("animation_end", function() {
			animation_end = true;
		});
	}
	
	self.step = function(){//this code looks like the old engine because i dont think
		//the door needs a snowstate. 
		//return;
		//log(animation_end)
		
		var _inst = self.get_instance();
		
		if(!instance_exists(obj_player)){
			return;
		} else {
			
			if(coll == noone){
		
				coll = instance_create_depth(_inst.x ,_inst.y,_inst.depth - 1, obj_square_16);
		
				coll.image_yscale = _inst.sprite_height / 16; 
		
				if(!multidirectional){
					coll.x += (sign(_inst.image_xscale) / 2) + 0.5;
					coll.image_xscale = (_inst.sprite_width - 1) / 16;
				} else {
					coll.x += (sign(_inst.image_xscale) / 2) + 0.5;
					coll.image_xscale = (_inst.sprite_width - 2) / 16;
				}
			}
			
			//var _player = instance_nearest(_inst.x,_inst.y, obj_player);
		}
		
		if(!activated){
			activated = physics.check_place_meeting(_inst.x,_inst.y, obj_player);
			
			if (activated){
				self.publish("animation_play", { name: "open" });
				animation_end = false;
				state_segment = 1;
				time_offset = CURRENT_FRAME + time_delay;
				curr_player = instance_nearest(self.get_instance().x, self.get_instance().y, obj_player)
				with(obj_player){
					if(self != other.curr_player){
						self.x = other.curr_player.x;
						self.y = other.curr_player.y;
					}
					components.get(ComponentPlayerInput).__locked = true;
					components.get(ComponentPlayerMove).locked = true;
					components.get(ComponentPhysics).velocity = new Vec2(0, 0); 
					components.get(ComponentPhysics).grav = new Vec2(0, 0); 
					components.get(ComponentAnimationShadered).animation.__speed = 0;
				}
				with(obj_camera){
					components.get(ComponentCamera).movement_limit_x = 100000;
					components.get(ComponentCamera).bounds = noone;
					components.get(ComponentCamera).target = noone;
					components.get(ComponentCamera).update_pos(other.get_instance().x - GAME_W, components.get(ComponentCamera).y)
					other.curr_cam = components.get(ComponentCamera);
				}
				camera_total_movement = GAME_W;
			}
		}
		
		#region states
		if(activated){
			with(obj_player){
				components.get(ComponentPlayerInput).__locked = true;
				components.get(ComponentPlayerMove).locked = true;
			}
			switch(state_segment){
				case(1):
				//open the door
				if(animation_end){//this will trigger when animation end is called
					state_segment++;  
					with(obj_player){
						if(components.get(ComponentPhysics).is_on_floor())
							components.get(ComponentAnimationShadered).animation.__speed = 1;
					}
					coll.y -= 1025;
					self.publish("animation_play", { name: "stay_open" });
				}
		
				break;
				case(2):
		
				//with(curr_player){
					
					if(physics.check_place_meeting(_inst.x + 12,_inst.y, obj_player) || physics.check_place_meeting(_inst.x - 12,_inst.y, obj_player)){
						with(obj_player){
							x += (74/256) * (other.flipped * -2 + 1);
						}
						// the camera movement value is larger than snes, but its also 
						curr_cam.x += (flipped * -2 + 1) * (383/256);
					} else {
						state_segment++;
						with(obj_camera){
							components.get(ComponentCamera).target = other.curr_player;
						}
						prev_cam_x = curr_cam.x;
						self.publish("animation_play", { name: "close" });
						
						with(obj_player){
							if(components.get(ComponentPhysics).is_on_floor()){
								components.get(ComponentPlayerMove).fsm.change("idle");
							} else {
								components.get(ComponentPlayerMove).fsm.change("fall");
							}
							components.get(ComponentAnimationShadered).animation.__speed = 1;
							components.get(ComponentPhysics).grav = new Vec2(0, 0.25); 
						}
					}
				//}
		
				break;
				case(3):
				if(prev_cam_x == curr_cam.x){
					with(obj_player){
						x = floor(x) + (other.flipped * -2 + 1);
					}
					coll.y = _inst.y;
					//self.publish("animation_play", { name: "stay_closed" });
					state_segment = -1;
					activated = false;
					with(obj_player){
						components.get(ComponentPlayerMove).locked = false;
					}
					if(!spawn_boss) {
						with(obj_player){
							components.get(ComponentPlayerInput).__locked = false;
						}
						return;
					}
					
					
					with(obj_camera){
						components.get(ComponentCamera).reset_movement_limits();
					}
					
					with(Boss_Spawn_Point){
						spawn_boss();
						log("boss spawned")
					}
				} else {
					prev_cam_x = curr_cam.x;
				}
				break;
			}
		} else {
			//if the nearest player is on the left, flip yourself and move back to where you should be
			coll.x = _inst.x - 15;
			coll.y = _inst.y;
				if(flipped){
					if(instance_nearest(_inst.x,_inst.y,obj_player).x < _inst.x){
						flipped = false;
						//publish("animation_xscale", 1)
						//_inst.image_xscale = 1;
						//_inst.x -= 32;
					}
				} else {
					if(instance_nearest(_inst.x - 32,_inst.y,obj_player).x > _inst.x){
						flipped = true;
						//publish("animation_xscale", -1)
						//_inst.image_xscale = -1;
						//_inst.x += 32;
					}
				}
		}
		#endregion
		
		//log(_inst.y)
		animation_end = false;
	}
	
	self.init = function(){
		
		self.publish("animation_play", { name: "close" });
		
		var _inst = self.get_instance();
		
		_inst.mask_index = Sprite47;
		
		_inst.components.get(ComponentPhysics).grav = new Vec2(0, 0); 
		_inst.components.get(ComponentPhysics).velocity = new Vec2(0, 0); 
		
		_inst.visible = true;
		
		log(_inst.components.get(ComponentAnimationShadered).animation.__animation)
	}
}