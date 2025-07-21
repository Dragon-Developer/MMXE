function ComponentCharge() : ComponentBase() constructor{
	self.start_time = -1;
	self.input = noone;
	self.node_parent = noone;
	self.current_weapon = noone;
	self.shoot_input = "shoot";
	self.shoot_inputs = ["shoot"]
	self.charging = false;
	
	self.init = function(){
		self.publish("animation_play", { 
					name: "charge_1"
				}); 
				self.publish("animation_visible", false);
	}
	
	self.on_register = function(){
		self.subscribe("child_connected_to_parent", function() {
			node_parent = self.get_instance().components.get(ComponentNode).node_parent;
			input = node_parent.get_instance().components.get(ComponentPlayerInput);
			node_parent.get_instance().components.get(ComponentWeaponUse).charge = self;
		});
	}
	
	self.step = function(){
		self.charge();
	}
	
	//I am gonna manually call this from componentWeaponUse
	self.charge = function(){
		var _pressed = false;
		var _released = false;
		if(self.input != noone) {
			//one may say that im compensating
			//they would not be wrong
			for(var p = 0; p < array_length(self.shoot_inputs); p++){
				if(self.input.get_input_released(self.shoot_inputs[p])){
					_released = true;
				}
				//should decouple these
				if(self.input.get_input_pressed(self.shoot_inputs[p])){
					_pressed = true;
				}
			}
		}

		if(_released && charging){//prevent 'stored charge shots'
			self.start_time = -1;//if it's -1, then we arent charging. 
			self.publish("animation_visible", false);
			charging = false;
		} else if(_pressed && !charging){//prevent charge shot delay rapidly increasing
			self.start_time = CURRENT_FRAME;
			charging = true;
		}
		
		self.get_instance().x = self.get_instance().components.get(ComponentNode).node_parent.get_instance().x;
		self.get_instance().y = self.get_instance().components.get(ComponentNode).node_parent.get_instance().y;

		if(self.start_time == -1 || self.start_time + self.current_weapon.charge_time[0] > CURRENT_FRAME) return;
		
		if(floor(self.start_time + self.current_weapon.charge_time[0]) == floor(CURRENT_FRAME))
			self.publish("animation_visible", true);
		if(floor(self.start_time + self.current_weapon.charge_time[0] + 1) == floor(CURRENT_FRAME))
			self.publish("animation_visible", true);
		
		var _shot_code = noone;
		
		//for(var p = 0; p < array_length(self.current_weapon.charge_time); p++){
		for(var p = array_length(self.current_weapon.charge_time) - 1; p > -1; p--){
			if(self.start_time + self.current_weapon.charge_time[p] < CURRENT_FRAME && 
			self.current_weapon.charge_limit >= p + 1 && _shot_code == noone){
				_shot_code = self.current_weapon.data[p + 1];
			}
		}
		
		if(_shot_code != noone){
			self.publish("animation_play", { 
				name: "charge_" + string(array_get_index(self.current_weapon.data, _shot_code)),
				reset: false
			});
		}
	}
}