function ComponentWeaponUse() : ComponentBase() constructor{
	self.shot_end_time = 0;
	self.current_weapon = [0,0,0];//i highly doubt these will change much at all during gameplay
	self.weapon_list = [
	xBuster,
	XenoMissile
	];
	self.charge = noone;
	self.charge_time = [30, 105, 180, 255];
	self.shoot_inputs = ["shoot","shoot2","shoot3", "shoot4"]
	
	self.serializer
		.addVariable("shot_end_time")
		.addVariable("current_weapon")
		.addVariable("weapon_list")
		
	self.on_register = function(){
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
			//need input to see if youre shooting
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
			//idk physics would be good for speed burner/charge kick
		});
	}
	
	self.step = function(){
		
		if(self.input.get_input_pressed("switchLeft")){
			self.current_weapon[0]++;
			self.current_weapon[0] = self.current_weapon[0] mod array_length(self.weapon_list)
		}
		
		if(self.charge != noone){
			self.charge.shoot_inputs = self.shoot_inputs;
		}
		
		var _anim_name = self.get_instance().components.find("animation").animation.__animation;
		
		if(self.shot_end_time < CURRENT_FRAME){
			self.get_instance().components.find("animation").animation.__type = "normal";
			if(_anim_name == "shoot"){
				self.publish("animation_play", { 
					name: "idle"
				});
			}
		} else {
		
			if(_anim_name == "idle"){
				self.publish("animation_play", { 
					name: "shoot"
				});
			}
		}
		
		for(var g = 0; g < array_length(self.shoot_inputs);g++){
			self.shoot(self.shoot_inputs[g], g);
		}
	}
	
	self.shoot = function(_input, _id){
		if(self.input.get_input_pressed(_input) || self.input.get_input_released(_input)){
			
			var _shot_index = 0;
			var _shot_code = {};
			
			with(_shot_code){
				script_execute(other.weapon_list[other.current_weapon[_id]]);
			}
			log(_shot_code)
			
			if(self.input.get_input_released(_input) && self.charge != noone){
				//nobody said i was a CLEAN coder
				
				if(self.charge.charging){
					for(var p = 0; p < array_length(charge_time); p++){
						
						if(self.charge.start_time + charge_time[p] < CURRENT_FRAME
						&& _shot_code.charge_limit >= p + 1){
							_shot_index = p + 1;
						}
					}
				}
				if(_shot_index == 0){
					return;
				}
			}
			
			
			_shot_code = _shot_code.data[_shot_index];
			
			var _anim_name = self.get_instance().components.get(ComponentAnimationPalette).animation.__animation;
			if(_anim_name == "idle"){
				self.publish("animation_play", {name: "shoot"})
			}
			
			if(_anim_name == "shoot"){
				self.publish("animation_play", {name: "shoot", reset: true})
			}
			
			//set the time for shooting to end
			self.shot_end_time = CURRENT_FRAME + 15;
			self.get_instance().components.get(ComponentAnimationPalette).animation.__type = "shoot";
			
			
			var _shot = instance_create_depth(self.get_instance().x,self.get_instance().y,self.get_instance().depth, spawn_projectile);
			//apply_shot_offset(_shot);
			_shot.dir = self.get_instance().components.find("animation").animation.__xscale;
			
			if(_anim_name == "wall_slide"){
				_shot.dir*= -1
			}
			
			_shot.weaponData = _shot_code;
		}
	}
} 

//seperated because it causes crashes
function ComponentWeaponUseOld() : ComponentBase() constructor{
	//this is where weapons are used. 
	
	/*
		so uhh i have no idea how im gonna make this work. 
		
		ill start with inputs and tacking on the shoot animation.
	*/
	
	//dark said no int based timers because we plastered them everywhere.
	//current_time is in milliseconds! use CURRENT_FRAME!
	self.shot_end_time = 0;
	self.current_weapon = [0,0,0];//i highly doubt these will change much at all during gameplay
	self.weapon_list = [
	new xBuster(),
	new XenoMissile()
	];
	self.charge = noone;
	self.shoot_inputs = ["shoot","shoot2","shoot3", "shoot4"]
	
	self.serializer
		.addVariable("shot_end_time")
		.addVariable("current_weapon")
		.addVariable("weapon_list")
	
	self.init = function(){
		//current_weapon = 0;
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
		
		if(self.input.get_input_pressed("switchLeft")){
			self.current_weapon[0]++;
			self.current_weapon[0] = self.current_weapon[0] mod array_length(self.weapon_list)
		}
		
		if(self.charge != noone){
			//log(self.current_weapon)
			self.charge.charge_time = 
			self.weapon_list[
			self.current_weapon[0]
			].charge_time;//the first buster slot
			self.charge.shoot_inputs = self.shoot_inputs;
		}
		
		if(self.shot_end_time < CURRENT_FRAME){
			//probably shouldnt manually set this but meh
			self.get_instance().components.find("animation").animation.__type = "normal";
			var _anim_name = self.get_instance().components.find("animation").animation.__animation;
			if(_anim_name == "shoot"){
				self.publish("animation_play", { 
					name: "idle"
				});
			}
		} else { //can use the time when you have the shoot animation up 
			var _anim_name = self.get_instance().components.get(ComponentAnimationPalette).animation.__animation;
		
			if(_anim_name == "idle"){
				self.publish("animation_play", { 
					name: "shoot"
				});
			}
		}
		for(var g = 0; g < array_length(self.shoot_inputs);g++){
			self.shoot(self.shoot_inputs[g], g);
		}
	}
	
	self.shoot = function(_input, _id){
		if(self.input.get_input_pressed(_input) || self.input.get_input_released(_input)){
			
			var _shot_code = noone;
			
			if(self.input.get_input_released(_input) && self.charge != noone){
				//nobody said i was a CLEAN coder
				
				if(self.charge.charging){
					for(var p = 0; p < array_length(
					self.weapon_list[self.current_weapon[_id]].charge_time); p++){
						
						if(self.charge.start_time + self.weapon_list[_id][self.current_weapon[_id]].charge_time[p] < CURRENT_FRAME
						&& self.weapon_list[_id][self.current_weapon[_id]].charge_limit >= p + 1){
							_shot_code = self.weapon_list[self.current_weapon[_id]].data[p + 1];
						}
					}
				}
				if(_shot_code == noone){
					return;
				}
			} else {
				_shot_code = self.weapon_list[self.current_weapon[_id]].data[0];
			}
			
			var _anim_name = self.get_instance().components.get(ComponentAnimationPalette).animation.__animation;
			if(_anim_name == "idle"){
				self.publish("animation_play", {name: "shoot"})
			}
			
			if(_anim_name == "shoot"){
				self.publish("animation_play", {name: "shoot", reset: true})
			}
			
			//set the time for shooting to end
			self.shot_end_time = CURRENT_FRAME + 15;
			self.get_instance().components.get(ComponentAnimationPalette).animation.__type = "shoot";
			
			//make the projectile
			var _shot = instance_create_depth(self.get_instance().x,self.get_instance().y,self.get_instance().depth, spawn_projectile);
			apply_shot_offset(_shot);
			_shot.dir = self.get_instance().components.get(ComponentAnimationPalette).animation.__xscale;
			
			if(_anim_name == "wall_slide"){
				_shot.dir*= -1
			}
			
			_shot.weaponData = _shot_code;
		
		}
	}
	
	self.apply_shot_offset = function(_shot){
		//ugh
		
	}
}
