function xBusterX2() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster23Data,xBuster24_1Data,xBuster25_1Data];
	self.charge_limit = 4;
	self.cost = 0;
	self.title = "X BUSTER";
	self.description = "Upgraded Mega Buster"
}

function xBuster23Data() : ProjectileData() constructor{
	self.comboiness = 2;
	self.damage = 3;
	self.shot_limit = 3;
	
	self.animation = "xShot3X2";
	self.hitbox_scale = new Vec2(24,24);
	
	self.create = function(_inst){
		//_inst.components.publish("animation_play", { name: "xShot3X1" });
		WORLD.play_sound("shoot_3");
	}
	self.step = function(_inst){
		var _hspd = 0;
		if (CURRENT_FRAME <= self.init_time + 5) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 6;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 6.5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 7;
		else _hspd = 7.5;
		_inst.x += _hspd * self.dir;
	}
}

function xBuster24_1Data() : ProjectileData() constructor{
	self.comboiness = 5;//all the drill bits should connect
	self.damage = 2;
	self.animation = "xShot2";
	self.stock_shot = xBuster35_2Data;
	self.hitbox_scale = new Vec2(24,24);
	self.animation_append = "db_buster_right";
	self.set_animation_instead = true;
	
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

function xBuster25_1Data() : ProjectileData() constructor{
	self.comboiness = 5;//all the drill bits should connect
	self.damage = 3;
	self.animation = "xShot4X3";
	self.stock_shot = xBuster35_2Data;
	self.hitbox_scale = new Vec2(24,24);
	self.animation_append = "db_buster_right";
	self.set_animation_instead = true;
	
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

function xBuster25_2Data() : ProjectileData() constructor{
	self.comboiness = 15;//all the drill bits should connect
	self.damage = 5;
	self.animation = "undefined";
	self.stock_shot = xBuster12Data;
	self.hitbox_scale = new Vec2(24,24);
	self.animation_append = "db_buster_left";
	self.set_animation_instead = true;
	
	self.particle_radius = -12;
	self.rotation_strength = 3;
	
	self.create = function(_inst){
		//_inst.components.publish("animation_play", { name: "xShot3X1" });
		WORLD.play_sound("shoot_3");
	}
	
	self.step = function(_inst){
		var _hspd = (CURRENT_FRAME - self.init_time) / 10
		_inst.x += _hspd * self.dir;
		
		WORLD.spawn_particle(new DrillBusterParticle(_inst.x + 6 * self.dir, _inst.y + sin((CURRENT_FRAME / 5) + (pi / 3) * 4) * particle_radius,self.dir, 0))
		WORLD.spawn_particle(new DrillBusterParticle(_inst.x + 6 * self.dir, _inst.y + sin((CURRENT_FRAME / 5) + (pi / 3) * 2) * particle_radius,self.dir, 0))
		WORLD.spawn_particle(new DrillBusterParticle(_inst.x + 6 * self.dir, _inst.y + sin(CURRENT_FRAME / 5) * particle_radius,                 self.dir, 0))
	}
}