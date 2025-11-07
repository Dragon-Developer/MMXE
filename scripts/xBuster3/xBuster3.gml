function xBusterX3() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster33Data,xBuster34Data,xBuster34Data];
	self.charge_limit = 3;
	self.title = "X BUSTER";
	self.description = "Mega Buster Mark 17"
}

function xBuster33Data() : ProjectileData() constructor{
	self.comboiness = 2;
	self.damage = 3;
	self.shot_limit = 3;
	
	self.animation = "xShot3X3";
	self.hitbox_scale = new Vec2(24,24);
	self.animation_append = "_throw";
	
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

function xBuster34Data() : ProjectileData() constructor{
	self.comboiness = 15;//all the drill bits should connect
	self.damage = 32;
	self.animation = "xShot4X3";
	self.hitbox_scale = new Vec2(24,24);
	self.animation_append = "_throw";
	
	self.create = function(_inst){
		//_inst.components.publish("animation_play", { name: "xShot3X1" });
		WORLD.play_sound("shoot_3");
	}
	
	self.step = function(_inst){
		var _hspd = 0;
		if (CURRENT_FRAME == self.init_time + 5) _hspd = 6;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 7;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 7.5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 8;
		else _hspd = 8.5;
		_inst.x += _hspd * self.dir;
	}
}