function SpinningWheel() : ProjectileWeapon() constructor{
	self.data = [SpinningWheelData,SpinningWheelData,SpinningWheelData,SpinningWheelData,SpinningWheelData];
	self.charge_limit = 0;
}

function SpinningWheelData() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 2;
	self.hspd = 0;
	self.vspd = 0;
	self.bounce_count_max = 4;
	self.bounce_count = 0;
	self.create = function(_inst){
		_inst.components.publish("animation_play", { name: "wheel" });
		_inst.mask_index = spr_small_mask;
		_inst.components.get(ComponentPhysics).step = function(){};
		/*with(_inst.components.get(ComponentProjectile)){
			array_push(death_requirements, function(){
				return other.weaponCreate.bounce_count > other.weaponCreate.bounce_count_max;
			});
		}*/
		
	}
	self.step = function(_inst){
		if(self.init_time + 10 > CURRENT_FRAME) return;
		
		if(_inst.components.get(ComponentPhysics).check_place_meeting(_inst.x, _inst.y + self.vspd + 1, obj_square_16)){
			while(_inst.components.get(ComponentPhysics).check_place_meeting(_inst.x, _inst.y + self.vspd, obj_square_16)){
				_inst.y--;
			}
			self.hspd = 3;
			self.vspd = 0;
		} else {
			//self.hspd *= 0.95;
			self.vspd += 0.15;
			self.vspd = clamp(self.vspd, 0, 3)
		}
		comboiness+= 0.1;
		
		if(_inst.components.get(ComponentPhysics).check_place_meeting(_inst.x + self.dir * self.hspd, _inst.y, obj_square_16)){
			self.dir *= -1;
			_inst.components.publish("animation_xscale", self.dir);
			self.bounce_count++;
			if(self.bounce_count > self.bounce_count_max)
				ENTITIES.destroy_instance(_inst);
		}
		
		if(!is_undefined(_inst) && instance_exists(_inst)){
			_inst.x += hspd * self.dir;
			_inst.y += vspd;
		}
	}
}