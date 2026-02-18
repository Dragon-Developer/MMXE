function SpinningWheel() : ProjectileWeapon() constructor{
	self.data = [SpinningWheelData,SpinningWheelData,SpinningWheelData,SpinningWheelData,SpinningWheelData];
	self.charge_limit = 0;
	self.weapon_palette = [
		#217339,//Blue Armor Bits
		#009442,
		#00c652,
		#ad6bef,//Under Armor Teal Bits
		#ce94ff,
		#ffdeff,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	self.title = "S. WHEEL";
}

function SpinningWheelData() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 2;
	self.real_comboiness = 2;
	self.hspd = 0;
	self.vspd = 0;
	self.bounce_count_max = 4;
	self.bounce_count = 0;
	
	self.animation = "wheel";
	
	self.create = function(_inst){
		_inst.mask_index = spr_small_mask;
		
	}
	self.step = function(_inst){
		if(self.init_time + 10 > CURRENT_FRAME) return;
		
		if(projectile_collision_check(_inst.x, _inst.y + self.vspd + 1, self.hitbox_scale.x, self.hitbox_scale.y, obj_square_16)){
			while(projectile_collision_check(_inst.x, _inst.y + self.vspd, self.hitbox_scale.x, self.hitbox_scale.y, obj_square_16)){
				_inst.y--;
			}
			self.hspd = 3;
			self.vspd = 0;
		} else {
			//self.hspd *= 0.95;
			self.vspd += 0.15;
			self.vspd = clamp(self.vspd, 0, 3)
		}
		real_comboiness+= 0.1;
		comboiness = clamp(floor(real_comboiness), 0, 5)
		
		if(projectile_collision_check(_inst.x + self.dir * self.hspd, self.hitbox_scale.x, self.hitbox_scale.y, _inst.y, obj_square_16)){
			self.dir *= -1;
			//_inst.components.publish("animation_xscale", self.dir);
			self.bounce_count++;
			if(self.bounce_count > self.bounce_count_max)
				PROJECTILES.destroy_projectile(self)
		}
		
		if(!is_undefined(_inst) && instance_exists(_inst)){
			_inst.x += hspd * self.dir;
			_inst.y += vspd;
		}
	}
}