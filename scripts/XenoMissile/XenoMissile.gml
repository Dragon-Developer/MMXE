function XenoMissile() : ProjectileWeapon() constructor{
	self.data = [XenoMissileData,XenoMissileData,XenoMissileData,XenoMissileData,XenoMissileData];
	self.charge_limit = 0;
	self.weapon_palette = [
		#203080,//Blue Armor Bits
		#0040f0,
		#0080f8,
		#1858b0,//Under Armor Teal Bits
		#50a0f0,
		#78d8f0,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
}

function XenoMissileData() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	self.hspd = 0;
	self.create = function(_inst){
		//log(init_time)
		//may make this default
		_inst.components.publish("animation_play", { name: "missile" });
		_inst.mask_index = spr_lemon_mask;
	}
	self.step = function(_inst){
		self.hspd += 0.1;
		if(!is_undefined(_inst))
			_inst.x += hspd * self.dir;
	}
}