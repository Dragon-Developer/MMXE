function CursePinch() : ProjectileWeapon() constructor{
	self.data = [CursePinchData,CursePinchData,CursePinchData,ChargedCursePinch,ChargedCursePinch];
	self.charge_limit = 4;
	self.weapon_palette = [
		#402848,//Blue Armor Bits
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
	self.title = "CURSE P.";
}

function CursePinchData() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	self.hspd = 0;
	self.shot_limit = 5;
	self.animation = "curse_pinch";
	self.create = function(_inst){
		//_inst.components.publish("animation_play", { name: "xShot3X1" });
		WORLD.play_sound("rolling_shield_dink");
	}
	self.step = function(_inst){
		self.hspd += 0.25;
		self.hspd = clamp(self.hspd,0,3)
		if(!is_undefined(_inst))
			_inst.x += hspd * self.dir;
	}
}

function ChargedCursePinch() : ProjectileData() constructor{
	self.comboiness = 2;
	self.damage = 3;
	self.shot_limit = 2;
	
	self.animation = "charged_curse_pinch";
	self.hitbox_scale = new Vec2(24,24);
	
	self.create = function(_inst){
		//_inst.components.publish("animation_play", { name: "xShot3X1" });
		WORLD.play_sound("shoot_3");
	}
	self.step = function(_inst){
		var _hspd = 0;
		if (CURRENT_FRAME == self.init_time + 5) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 6;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 6.5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 7;
		else _hspd = 7.5;
		_inst.x += _hspd * self.dir;
	}
}