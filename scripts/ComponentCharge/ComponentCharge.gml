function ComponentCharge() : ComponentBase() constructor{
	self.start_time = -1;
	self.input = noone;
	self.node_parent = noone;
	self.current_weapon = noone;
	self.shoot_input = "shoot";
	self.shoot_inputs = ["shoot"]
	self.charging = false;
	self.charge_time = [30, 105, 180, 255]
	//theres no way to get hex from other sources and everything expects hex
	self.charge_colors = global.availible_characters[global.character_index].charge_colors;
	self.charge_limit = 2;//2
	
	self.charge_sound = undefined;
	self.outline_color = undefined;
	
	self.init = function(){
		self.publish("animation_play", { 
					name: "charge_1"
				}); 
		self.publish("animation_visible", false);
		self.publish("character_set", "player");
		find("animation").set_subdirectories(["/normal"]);
		find("animation").load_sprites();
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
		
		var _wap = {}
		
		with(_wap){
			script_execute(other.current_weapon)
		}
		
		var _weapon_max_charge = _wap.charge_limit;
		
		if(self.charge_limit <= 0 || _weapon_max_charge <= 0) return;
		
		var _charge_limit = min(self.charge_limit, _weapon_max_charge)
		
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
			//self.publish("animation_visible", false);
			WORLD.stop_sound(self.charge_sound);
			charging = false;
			self.publish("animation_visible", false);
			var _weap_pal = node_parent.get(ComponentWeaponUse).weapon_palette;
			for(var i = 0; i < array_length(global.availible_characters[global.character_index].default_palette); i++){
				node_parent.find("animation").set_palette_color(i, global.availible_characters[global.character_index].default_palette[i]);
			}
			for(var i = 0; i < array_length(_weap_pal); i++){
				node_parent.find("animation").set_palette_color(i, _weap_pal[i]);
			}
		} else if(_pressed && !charging){//prevent charge shot delay rapidly increasing
			self.start_time = CURRENT_FRAME;
			self.charge_sound = WORLD.play_sound("charge");
			charging = true;
			self.publish("animation_visible", true);
		}
		
		self.get_instance().x = self.get_instance().components.get(ComponentNode).node_parent.get_instance().x;
		self.get_instance().y = self.get_instance().components.get(ComponentNode).node_parent.get_instance().y;

		//log(find("animation").animation.__visible)
		//log(find("animation").animation.__animation)
		
		if(self.start_time == -1 || 
		self.start_time + self.charge_time[0] >= CURRENT_FRAME) {
			self.publish("animation_play", { 
				name: "charge_0",
				reset: false
			});
			self.get_instance().x = -1000;
			self.get_instance().y = -1000;
			self.get_instance().visible = false;
			return;
		} else {
			self.get_instance().visible = true;
			//charge effect
			
			if(node_parent == -4) return;
			
			if((self.start_time - CURRENT_FRAME) % 2 == 0){
				var _charge_amount = 0;
				
				if(self.start_time + self.charge_time[1] <= CURRENT_FRAME && _charge_limit > 0)
					_charge_amount = 1;
				
				if(self.start_time + self.charge_time[2] <= CURRENT_FRAME && _charge_limit > 1)
					_charge_amount = 2;
				
				if(self.start_time + self.charge_time[3] <= CURRENT_FRAME && _charge_limit > 2)
					_charge_amount = 3;
				
				for(var i = 0; i < array_length(self.charge_colors[_charge_amount]); i++){
					node_parent.find("animation").set_palette_color(i, self.charge_colors[clamp(_charge_amount, 0, _charge_limit - 1)][i]);
				}
			} else {
				var _weap_pal = node_parent.get(ComponentWeaponUse).weapon_palette;
				for(var i = 0; i < array_length(global.availible_characters[global.character_index].default_palette); i++){
					node_parent.find("animation").set_palette_color(i, global.availible_characters[global.character_index].default_palette[i]);
				}
				for(var i = 0; i < array_length(_weap_pal); i++){
					node_parent.find("animation").set_palette_color(i, _weap_pal[i]);
				}
			}
		}
		
		if(self.start_time + self.charge_time[_charge_limit - 1] == CURRENT_FRAME && global.settings.charge_flash){
			WORLD.play_sound("full_charge");
			var _inst = self.get_instance();
			WORLD.spawn_particle(new CompleteParticle(_inst.x, _inst.y, 1))
		}
		
		var _shot_code = noone;
		
		//for(var p = 0; p < array_length(self.current_weapon.charge_time); p++){
		for(var p = array_length(self.charge_time) - 1; p > -1; p--){
			if(self.start_time + self.charge_time[p] < CURRENT_FRAME && 
			_charge_limit >= p + 1 && _shot_code == noone){
				_shot_code = p;
			}
		}
		
		self.publish("animation_play", { 
			name: "charge_" + string(_shot_code + 1),
			reset: false
		});
	}
}