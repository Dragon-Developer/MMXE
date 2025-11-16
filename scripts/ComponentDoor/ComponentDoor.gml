function ComponentDoor() : ComponentBase() constructor{
	
	/*
		this whole things is jank incarnate. it works the way i want it to though!
	*/
	
	time_delay = 90;
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
	boss_spawn_timer = -1;

	coll = noone;
	self.serializer = new NET_Serializer();
	//self.serializer.addVariable("boss_spawn_timer")
	//self.serializer.addVariable("time_offset")
	//self.serializer.addVariable("state_segment")
	//self.serializer.addVariable("curr_player")
	
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
		
		switch(state_segment){
			case(-1):
				self.publish("animation_play", { name: "stay_closed" });
			break;
			case(2):
				self.publish("animation_play", { name: "stay_open" });
			break;
		}
		
		if(!activated){
			activated = physics.check_place_meeting(_inst.x,_inst.y, obj_player);
			time_offset = CURRENT_FRAME + time_delay;
			if (activated){
				self.publish("animation_play", { name: "open" });
				animation_end = false;
				state_segment = 1;
				time_offset = CURRENT_FRAME + time_delay;
				curr_player = physics.get_place_meeting(_inst.x, _inst.y, obj_player);
				if(curr_player == undefined){
					curr_player = instance_nearest(_inst.x, _inst.y, obj_player)
				}
				curr_player.x = _inst.x + (16 + sprite_get_width(curr_player.mask_index) / 2) * (flipped * 2 - 1);
				curr_player.components.get(ComponentPlayerInput).__locked = true;
				curr_player.components.get(ComponentPlayerMove).locked = true;
				curr_player.components.get(ComponentPhysics).velocity = new Vec2(0, 0); 
				curr_player.components.get(ComponentPhysics).grav = new Vec2(0, 0); 
				curr_player.components.get(ComponentAnimationShadered).animation.__speed = 0;
				if(curr_player.components.get(ComponentPlayerInput).get_player_index() == global.local_player_index){
					with(obj_camera){
						//components.get(ComponentCamera).target = noone;
						//other.curr_cam = components.get(ComponentCamera);
					}
				} else {
					curr_cam = new Vec2(0,0)
				}
				camera_total_movement = GAME_W;
			}
			
			coll.x = _inst.x - 15;
			coll.y = _inst.y;
			if(flipped){
				if(instance_nearest(_inst.x,_inst.y,obj_player).x < _inst.x){
					flipped = false;
				}
			} else {
				if(instance_nearest(_inst.x - 32,_inst.y,obj_player).x > _inst.x){
					flipped = true;
				}
			}
			
		} else {
			if(curr_player == undefined){
				curr_player = instance_nearest(_inst.x, _inst.y, obj_player)
			}
			
			for(var w = 0; w < instance_number(obj_player); w++){
				var _plr = instance_find(obj_player, w);
				if(_plr == curr_player) continue;
				
				var _px = _plr.x;
				var _diff = _px - self.get_instance().x
				
				if(abs(_diff) < 32){
					
					if(_diff > 0){
						instance_find(obj_player, w).x += 4;
					} else {
						instance_find(obj_player, w).x -= 4;
					}
					
				}
			}
			
			curr_player.components.get(ComponentPlayerInput).__locked = true;
			curr_player.components.get(ComponentPlayerMove).locked = true;
			switch(state_segment){
				case(1):
				//open the door
				if(time_offset <= CURRENT_FRAME){//this will trigger when animation end is called
					state_segment++;  
					if(curr_player.components.get(ComponentPhysics).is_on_floor())
						curr_player.components.get(ComponentAnimationShadered).animation.__speed = 1;
					coll.y -= 4096;
					self.publish("animation_play", { name: "stay_open" });
					log("DOOR OPEN")
				} else {
					curr_player.x = _inst.x + (16 + sprite_get_width(curr_player.mask_index) / 2) * (flipped * 2 - 1);
				}
		
				break;
				case(2):
				if(physics.check_place_meeting(_inst.x + 12,_inst.y, obj_player) || physics.check_place_meeting(_inst.x - 12,_inst.y, obj_player)){
					curr_player.x += (74/256) * (flipped * -2 + 1);
					curr_player.components.get(ComponentAnimationShadered).animation.__speed = 1;
					boss_spawn_timer = CURRENT_FRAME + 90;
					//curr_cam_x += (flipped * -2 + 1) * (383/256);
				} else {
					state_segment++;
					if(curr_player.components.get(ComponentPlayerInput).get_player_index() == global.local_player_index){
						with(obj_camera){
							//components.get(ComponentCamera).target = other.curr_player;
						}
					}
					self.publish("animation_play", { name: "close" });
					if(curr_player.components.get(ComponentPhysics).is_on_floor()){
						curr_player.components.get(ComponentPlayerMove).fsm.change("idle");
					} else {
						curr_player.components.get(ComponentPlayerMove).fsm.change("fall");
					}
					curr_player.components.get(ComponentPhysics).grav = new Vec2(0, 0.25); 
				}
		
				break;
				case(3):
				if(boss_spawn_timer <= CURRENT_FRAME){
					curr_player.x = _inst.x + (30 + sprite_get_width(curr_player.mask_index) / 2) * (flipped * -2 + 1);
					coll.y = _inst.y;
					//self.publish("animation_play", { name: "stay_closed" });
					if(boss_spawn_timer + 5 <= CURRENT_FRAME){
						state_segment = -1;
						activated = false;
						curr_player.components.get(ComponentPlayerMove).locked = false;
						curr_player.components.get(ComponentPlayerInput).__locked = false;
					}
					curr_player.components.get(ComponentPlayerMove).locked = false;
					curr_player.components.get(ComponentPlayerInput).__locked = false;
					if(IS_OFFLINE)
						with(par_boss){
							components.get(ComponentBoss).fsm.change("enter")
						}
				} else {
					curr_player.x = _inst.x + (30 + sprite_get_width(curr_player.mask_index) / 2) * (flipped * -2 + 1);
				}
				break;
			}
		}
		
		animation_end = false;
	}
	
	self.init = function(){
		
		self.publish("animation_play", { name: "close" });
		
		var _inst = self.get_instance();
		
		_inst.mask_index = Sprite47;
		
		_inst.components.get(ComponentPhysics).grav = new Vec2(0, 0); 
		_inst.components.get(ComponentPhysics).velocity = new Vec2(0, 0); 
		
		_inst.visible = true;
		
		//log(_inst.components.get(ComponentAnimationShadered).animation.__animation)
	}
	
	self.draw = function(){
		var _inst = self.get_instance();
		draw_string(string(self.state_segment), _inst.x + 4, _inst.y - 8)
		draw_string(string(self.state_segment), _inst.x - 14, _inst.y - 8)
	}
}