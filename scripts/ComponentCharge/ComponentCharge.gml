function ComponentCharge() : ComponentBase() constructor{
	self.start_time = -1;
	self.input = noone;
	self.node_parent = noone;
	self.current_weapon = noone;
	
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
		//Charge reset/start
		if(self.input != noone) {
			if(self.input.get_input_released("shoot")){
				self.start_time = -1;//if it's -1, then we arent charging. 
				self.publish("animation_visible", false);
			} else if(self.input.get_input_pressed("shoot")){
				self.start_time = CURRENT_FRAME;
				self.publish("animation_visible", true);
			}
		}
		
		self.get_instance().x = self.get_instance().components.get(ComponentNode).node_parent.get_instance().x;
		self.get_instance().y = self.get_instance().components.get(ComponentNode).node_parent.get_instance().y;

		var _shot_code = noone;
		for(var p = 0; p < array_length(self.current_weapon.charge_time); p++){
		//for(var p = array_length(self.current_weapon.charge_time) - 1; p > 0; p--){
			if(self.start_time + self.current_weapon.charge_time[p] > CURRENT_FRAME && 
			self.current_weapon.charge_limit >= p + 1){
				_shot_code = self.current_weapon.data[p ];
			}
		}
		
		if(_shot_code != noone){
			self.publish("animation_play", { 
				name: "charge_" + string(array_get_index(self.current_weapon.data, _shot_code))
			});
		}
	}
}