function XenoMissile() : ProjectileWeapon() constructor{
	self.data = [XenoMissileData,XenoMissileData,XenoMissileData,XenoMissileData,XenoMissileData];
	self.charge_limit = 0;
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