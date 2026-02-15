function HermesBuster() : ProjectileWeapon() constructor{
	self.data = [HermesBuster1Data,HermesBuster2Data,HermesBuster3Data,HermesBuster4Data,HermesBuster5Data];
	self.charge_limit = 5;
	self.cost = 0;
	self.title = "X BUSTER";
	self.description = "Mega Buster Mark 17"
	
	self.weapon_palette = global.player_character[global.local_player_index].default_palette;
}

function HermesBuster1Data() : xBuster11Data() constructor{
	self.animation = "hermes_shot_0";
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else _hspd = 6.5;
		if(!is_undefined(_inst))
			_inst.x += _hspd * self.dir;
	}
}

function HermesBuster2Data() : xBuster12Data() constructor{
	self.animation = "hermes_shot_1";
}

function HermesBuster3Data() : xBuster13Data() constructor{
	
	self.animation = "hermes_shot_2";
	self.step = function(_inst){
		var _hspd = 0;
		if (CURRENT_FRAME == self.init_time + 5) _hspd = 5.5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 6.5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 7;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 7.5;
		else _hspd = 8;
		_inst.x += _hspd * self.dir;
	}
}

function HermesBuster4Data() : ProjectileData() constructor{
	self.comboiness = 5;
	self.damage = 2;
	self.vertical_speed = 0;
	self.piercing = true;
	
	self.animation = "hermes_shot_3";
	self.hitbox_scale = new Vec2(24,24);
	
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_3");
		log("bingus")
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

function HermesBuster5Data() : ProjectileData() constructor{
	self.comboiness = 15;
	self.damage = 2;
	self.vertical_speed = 0;
	self.piercing = true;
	
	self.animation = "hermes_shot_2";
	self.hitbox_scale = new Vec2(24,24);
	
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_3");
		PROJECTILES.create_projectile(_inst.x, _inst.y, dir, HermesBuster5UpData, self, tag);
		PROJECTILES.create_projectile(_inst.x, _inst.y, dir, HermesBuster5DownData, self, tag);
	}
	self.step = function(_inst){
		var _hspd = 0;
		if (CURRENT_FRAME == self.init_time + 5) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 6;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 6.5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 7;
		else _hspd = 7.5;
		
		var _forward = new Vec2(1, vertical_speed)
		_forward = _forward.normalize();
		_forward = _forward.multiply(_hspd);
		
		_inst.x += _forward.x * dir;
		_inst.y += _forward.y;
	}
}

function HermesBuster5UpData() : HermesBuster5Data() constructor{
	self.create = function(_inst){}
	self.vertical_speed = -1;
	self.animation = "hermes_shot_2_up";
}

function HermesBuster5DownData() : HermesBuster5UpData() constructor{
	self.create = function(_inst){}
	self.vertical_speed = 1;
	self.animation = "hermes_shot_2_down";
}