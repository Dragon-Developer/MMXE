function RockBuster() : ProjectileWeapon() constructor{
	self.data = [RockBuster1Data,RockBuster2Data,RockBuster3Data,RockBuster1PowerGearData,RockBuster4Data];
	self.charge_limit = 4;
	self.cost = 0;
	self.title = "R. BUSTER";
	self.description = "MEGA BUSTER MARK 5"
	
	self.weapon_palette = global.availible_characters[global.character_index].default_palette;
}


function RockBuster1Data() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 3;
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_1");
		WORLD.spawn_particle(new BassLemonFireParticle(_inst.x, _inst.y, 1))
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else if (CURRENT_FRAME - self.init_time > 24)_hspd = 6.25;
		if(!is_undefined(_inst))
			_inst.x += _hspd * self.dir;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new RockLemonDieParticle(_inst.x, _inst.y, 1))
	}
}
function RockBuster1PowerGearData() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 3;
	self.animation = "rock_lemon_power_gear";
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_1");
		WORLD.spawn_particle(new BassLemonFireParticle(_inst.x, _inst.y, 1))
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else if (CURRENT_FRAME - self.init_time > 24)_hspd = 6.25;
		if(!is_undefined(_inst))
			_inst.x += _hspd * self.dir;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new RockLemonDieParticle(_inst.x, _inst.y, 1))
	}
}

function RockLemonDieParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "rock_lemon_die";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 2;
	self.frame = 0;
	self.frame_max = 4;
	self.dir = _dir;
}

function RockBuster2Data() : ProjectileData() constructor{
	self.comboiness = 1;
	self.shot_limit = 3;
	
	self.hitbox_scale = new Vec2(16,16);
	self.hitbox_offset = new Vec2(16,0);
	self.animation = "rock_shot_1";

	self.create = function(_inst){
		WORLD.spawn_particle(new BassLimeFireParticle(_inst.x, _inst.y, 1))
		WORLD.play_sound("shoot_2");
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		//first 10 frames the shot sticks to the player. how do? pass the player!
		if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 6;
		else if (CURRENT_FRAME - self.init_time > 12)_hspd = 6.25;
		_inst.x += _hspd * self.dir;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LimeDieParticle(_inst.x + 16 * dir, _inst.y, self.dir))
	}
}

function RockBuster3Data() : ProjectileData() constructor{
	self.comboiness = 2;
	self.damage = 3;
	self.boss_damage = 3;
	self.shot_limit = 3;
	self.piercing = true;
	
	self.animation = "rock_shot_2";
	self.hitbox_scale = new Vec2(24,24);
	self.hitbox_offset = new Vec2(8,0);
	
	self.create = function(_inst){
		WORLD.spawn_particle(new BassFullShotFireParticle(_inst.x, _inst.y, 1))
		WORLD.play_sound("shoot_3");
	}
	self.step = function(_inst){
		var _hspd = 0;
		if (CURRENT_FRAME == self.init_time + 5) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 6;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 6.5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 7;
		else if (CURRENT_FRAME - self.init_time > 12) _hspd = 7.5;
		_inst.x += _hspd * self.dir;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new FullShotDieParticle(_inst.x - 8 * dir, _inst.y, self.dir))
	}
}

function RockBuster4Data() : ProjectileData() constructor{
	self.comboiness = 2;
	self.damage = 3;
	self.shot_limit = 3;
	self.piercing = true;
	
	self.animation = "rock_shot_2";
	self.hitbox_scale = new Vec2(24,24);
	self.hitbox_offset = new Vec2(8,0);
	self.start_time = CURRENT_FRAME + 40;
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_3");
		var _wepuse = instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse)
		_wepuse.shot_end_time = CURRENT_FRAME + 60;
	}
	self.step = function(_inst){
		var _hspd = 0;
		if (CURRENT_FRAME == self.init_time + 5) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 6;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 6.5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 7;
		else if (CURRENT_FRAME - self.init_time > 12) _hspd = 7.5;
		_inst.x += _hspd * self.dir;
		
		if(self.start_time == CURRENT_FRAME){
			PROJECTILES.create_projectile(_inst.x, _inst.y, dir, RockBuster42Data, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
		}
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new FullShotDieParticle(_inst.x - 8 * dir, _inst.y, self.dir))
	}
}

function RockBuster42Data() : RockBuster4Data() constructor{
	self.animation = "rock_shot_3_alt";
	
	self.step = function(_inst){
		var _hspd = 0;
		if (CURRENT_FRAME == self.init_time + 5) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 6;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 6.5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 7;
		else if (CURRENT_FRAME - self.init_time > 12) _hspd = 7.5;
		_inst.x += _hspd * self.dir * 1.1;
	}
}

function RockBuster5Data() : ProjectileData() constructor{
	self.comboiness = 2;
	self.damage = 3;
	self.shot_limit = 3;
	self.piercing = true;
	
	self.animation = "rock_shot_4";
	self.hitbox_scale = new Vec2(24,24);
	self.hitbox_offset = new Vec2(8,0);
	
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
		else if (CURRENT_FRAME - self.init_time > 12) _hspd = 7.5;
		_inst.x += _hspd * self.dir;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new FullShotDieParticle(_inst.x - 8 * dir, _inst.y, self.dir))
	}
}