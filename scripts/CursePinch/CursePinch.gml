function CursePinch() : ProjectileWeapon() constructor{
	self.data = [CursePinchData,CursePinchData,CursePinchData,CursePinchData,CursePinchData];
	self.charge_limit = 0;
	self.weapon_palette = [
		#403353,//Blue Armor Bits
		#692b8e,
		#a83cc6,
		#1e6c4f,//Under Armor Teal Bits
		#56bc91,
		#7ceab7,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	self.title = "CURSE M.";
}

function CursePinchData() : ProjectileData() constructor{
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