function ComponentWeaponUse() : ComponentBase() constructor{
	//this is where weapons are used. 
	
	/*
		so uhh i have no idea how im gonna make this work. 
		
		ill start with inputs and tacking on the shoot animation.
	*/
	
	//dark said no int based timers because we plastered them everywhere.
	//current_time is in milliseconds! use CURRENT_FRAME!
	self.shot_end_time = 0;
	self.current_weapon = 0;//the weapon data, not the projectile or melee data.
	self.weapon_list = [new xBuster()];
	self.charge = noone;
	
	self.serializer
		.addVariable("shot_end_time")
		.addVariable("current_weapon")
		.addVariable("weapon_list")
	
	self.init = function(){
		current_weapon = 0;
		//this system for the moment wont work if the animator has multiple other things that use it
		//but for the moment, the only other animator is the main player one. as long as we reset it
		//at the end of the script, we should be good
	}
	
	self.on_register = function(){
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
			//need input to see if youre shooting
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
			//idk physics would be good for speed burner/charge kick
		});
	}
	
	self.step = function(){
		self.charge.current_weapon = self.weapon_list[self.current_weapon];
		
		if(self.shot_end_time < CURRENT_FRAME){
			//probably shouldnt manually set this but meh
			self.get_instance().components.get(ComponentAnimation).animation.__type = "normal";
			var _anim_name = self.get_instance().components.get(ComponentAnimation).animation.__animation;
			if(_anim_name == "shoot"){
				self.publish("animation_play", { 
					name: "idle"
				});
			}
		} else { //can use the time when you have the shoot animation up 
			var _anim_name = self.get_instance().components.get(ComponentAnimation).animation.__animation;
		
			if(_anim_name == "idle"){
				self.publish("animation_play", { 
					name: "shoot"
				});
			}
		}
		
		if(self.input.get_input_pressed("shoot") || self.input.get_input_released("shoot")){
			
			var _shot_code = noone;
			
			if(self.input.get_input_released("shoot")){
				for(var p = 0; p < array_length(self.weapon_list[self.current_weapon].charge_time); p++){
					if(self.charge.start_time + self.weapon_list[self.current_weapon].charge_time[p] < CURRENT_FRAME
					&& self.weapon_list[self.current_weapon].charge_limit >= p + 1){
						_shot_code = self.weapon_list[self.current_weapon].data[p + 1];
					}
				}
				
				if(_shot_code == noone){
					return;
				}
			} else {
				_shot_code = self.weapon_list[self.current_weapon].data[0];
			}
			
			var _anim_name = self.get_instance().components.get(ComponentAnimation).animation.__animation;
			if(_anim_name == "idle"){
				self.publish("animation_play", {name: "shoot"})
			}
			
			if(_anim_name == "shoot"){
				self.publish("animation_play", {name: "shoot", reset: true})
			}
			
			//set the time for shooting to end
			self.shot_end_time = CURRENT_FRAME + 15;
			self.get_instance().components.get(ComponentAnimation).animation.__type = "shoot";
			
			//make the projectile
			var _shot = instance_create_depth(self.get_instance().x,self.get_instance().y,self.get_instance().depth, spawn_projectile);
			apply_shot_offset(_shot);
			_shot.dir = self.get_instance().components.get(ComponentAnimation).animation.__xscale;
			
			if(_anim_name == "wall_slide"){
				_shot.dir*= -1
			}
			
			_shot.weaponData = _shot_code;
		
		}
	}
	
	self.apply_shot_offset = function(_shot){
		//ugh
		
	}

/*

		//log(self.input.get_input_released("shoot"));Add commentMore actions
		if(self.charge_start_time == -1) return;
		
		if(self.charge_start_time + self.weapon_list[self.current_weapon].charge_time[3] < CURRENT_FRAME
					&& self.weapon_list[self.current_weapon].charge_limit >= 4){
			//this is too far! i didnt get graphics yet!
		} else if(self.charge_start_time + self.weapon_list[self.current_weapon].charge_time[2] < CURRENT_FRAME
					&& self.weapon_list[self.current_weapon].charge_limit >= 3){
			//this is too far! i didnt get graphics yet!
		} else if(self.charge_start_time + self.weapon_list[self.current_weapon].charge_time[1] < CURRENT_FRAME
					&& self.weapon_list[self.current_weapon].charge_limit >= 2){
				draw_sprite(Player_Charge_2,CURRENT_FRAME, self.get_instance().x,self.get_instance().y)
		} else if(self.charge_start_time + self.weapon_list[self.current_weapon].charge_time[0] < CURRENT_FRAME
					&& self.weapon_list[self.current_weapon].charge_limit >= 1){
				draw_sprite(Player_Charge_1,CURRENT_FRAME, self.get_instance().x,self.get_instance().y)
		} else {
			//log("no charge!")
		}

*/

}
