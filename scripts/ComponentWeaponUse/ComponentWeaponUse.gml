function ComponentWeaponUse() : ComponentBase() constructor{
	self.shot_end_time = 0;
	self.current_weapon = [0,0,0,0];//i highly doubt these will change much at all during gameplay
	self.weapon_list = [
	xBuster,
	XenoMissile
	];
	self.weapon_ammo = [28,28,28];
	self.weapon_max_ammo = 28;
	self.charge = noone;
	self.charge_time = [30, 105, 180, 255];
	self.shoot_inputs = ["shoot","shoot2","shoot3", "shoot4"]
	self.bar = noone;
	
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
		
		if self.bar != noone {
			self.bar.barValues = [self.weapon_ammo[self.current_weapon[0]]]
			self.bar.barValueMax = [self.weapon_max_ammo]
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
			
			
		log("QWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOP START")
			var _shot = instance_create_depth(self.get_instance().x,self.get_instance().y,self.get_instance().depth, spawn_projectile);
			self.apply_shot_offset(_shot);
			_shot.dir = self.get_instance().components.find("animation").animation.__xscale;
			
			if(_anim_name == "wall_slide"){
				_shot.dir*= -1
			}
			
			_shot.weaponData = _shot_code;
		}
	}
	
	self.apply_shot_offsets = function(_shot){
		log(self.get_instance().components.find("animation").animation.get_props())
		log("QWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOP END")
		//var _xOff = self.get_instance().components.find("animation").animation.shot_offset_x;
		//var _yOff = self.get_instance().components.find("animation").animation.shot_offset_y;
		
		//_shot.x += _xOff;
		//_shot.y += _yOff;
	}
} 