function xBuster() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster13Data,xBuster14Data,xBuster14Data];
	self.charge_limit = 4;
	self.cost = 0;
	self.title = "X BUSTER";
	self.description = "Mega Buster Mark 17"
	
	self.weapon_palette = global.availible_characters[global.character_index].default_palette;
}

function xBuster11Data() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 3;
	
	self.create = function(_inst){
		//log(init_time)
		//may make this default
		WORLD.play_sound("shoot_1");
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
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function xBuster12Data() : ProjectileData() constructor{
	self.comboiness = 1;//same combo damage as lemons, so it could be a good combo ender?
	self.damage = 2;
	self.shot_limit = 3;
	
	self.hitbox_scale = new Vec2(16,16);
	self.hitbox_offset = new Vec2(16,0);
	self.animation = "xShot2";

	self.create = function(_inst){
		//_inst.components.publish("animation_play", { name: "xShot2" });
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

function xBuster13Data() : ProjectileData() constructor{
	self.comboiness = 2;
	self.damage = 3;
	self.shot_limit = 3;
	self.piercing = true;
	
	self.animation = "xShot3X1";
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

function xBuster14Data() : ProjectileData() constructor{
	self.comboiness = 15;
	self.damage = 4;
	self.shot_limit = 3;
	self.piercing = true;
	self.particle_radius = 0;
	self.rotation_strength = 1.75;
	
	self.animation = "poopy joe";
	self.hitbox_scale = new Vec2(24,24);
	self.hitbox_offset = new Vec2(8,0);
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_3");
		
		PROJECTILES.create_projectile(_inst.x, _inst.y, dir, DrillBusterShieldData, PROJECTILES, tag);
		if(!global.settings.extra_particles){
			PROJECTILES.create_projectile(_inst.x, _inst.y, dir, xBuster14ClassicData, PROJECTILES, tag);
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
		}
		
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new FullShotDieParticle(_inst.x - 8 * dir, _inst.y, self.dir))
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else if (CURRENT_FRAME - self.init_time > 24) _hspd = 6.25;
		_inst.x += _hspd * self.dir;
		
		if(CURRENT_FRAME mod 2 == 0){
			WORLD.spawn_particle(new DrillBusterParticle(_inst.x + 6 * self.dir, _inst.y + sin((CURRENT_FRAME / 5) + (pi / 3) * 4) * particle_radius,self.dir, sin((CURRENT_FRAME / 5) + (pi / 3) * 4) * rotation_strength))
			WORLD.spawn_particle(new DrillBusterParticle(_inst.x + 6 * self.dir, _inst.y + sin((CURRENT_FRAME / 5) + (pi / 3) * 2) * particle_radius,self.dir, sin((CURRENT_FRAME / 5) + (pi / 3) * 2) * rotation_strength))
			WORLD.spawn_particle(new DrillBusterParticle(_inst.x + 6 * self.dir, _inst.y + sin(CURRENT_FRAME / 5) * particle_radius,                 self.dir, sin(CURRENT_FRAME / 5) * rotation_strength))
		}
	}
}


function xBuster14ClassicData() : ProjectileData() constructor{
	self.comboiness = 15;
	self.damage = 4;
	self.shot_limit = 3;
	self.piercing = true;
	self.particle_radius = -12;
	self.rotation_strength = 3;
	
	self.animation = "poopy joe";
	self.hitbox_scale = new Vec2(24,24);
	self.hitbox_offset = new Vec2(8,0);
	
	self.create = function(_inst){
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new FullShotDieParticle(_inst.x - 8 * dir, _inst.y, self.dir))
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else if (CURRENT_FRAME - self.init_time > 24) _hspd = 6.25;
		_inst.x += _hspd * self.dir;
		
		if(CURRENT_FRAME mod 2 == 0){
			WORLD.spawn_particle(new DrillBusterParticle(_inst.x + 6 * self.dir, _inst.y + sin((CURRENT_FRAME / 5) + (pi / 3) * 4) * particle_radius,self.dir, 0))
			WORLD.spawn_particle(new DrillBusterParticle(_inst.x + 6 * self.dir, _inst.y + sin((CURRENT_FRAME / 5) + (pi / 3) * 2) * particle_radius,self.dir, 0))
			WORLD.spawn_particle(new DrillBusterParticle(_inst.x + 6 * self.dir, _inst.y + sin(CURRENT_FRAME / 5) * particle_radius,                 self.dir, 0))
		}
	}
}

function DrillBusterShieldData() : ProjectileData() constructor{
	self.comboiness = 16;
	self.damage = 4;
	self.shot_limit = 3;
	self.piercing = true;
	self.time = 10;
	
	self.animation = "drill_effect";
	self.hitbox_scale = new Vec2(32,64);
	self.hitbox_offset = new Vec2(0,0);
	
	self.create = function(_inst){
	}
	self.step = function(_inst){
		_inst.x -= self.dir * 4;
		time--;
		if(time < 0) PROJECTILES.destroy_projectile(self)
	}
	self.destroy = function(_inst){
	}
}

function DrillBusterParticle(_x, _y, _dir, _vy) : ParticleBase() constructor{
	self.sprite = "drill_shot";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,_vy);
	self.position = new Vec2(_x,_y);
	self.time_max = 4;
	self.frame_max = 4;
	self.dir = _dir;
}

/*
if (dash) {
	if (global.dash_lemon_visible)
		sprite_index = spr_x_shot_11;
	else sprite_index = spr_x_shot_1;
	if (ds_exists(boss_damage, ds_type_map))
		boss_damage[? noone] = 2;
	atk = 2;
}

if (destroy)
{
	var t = destroy_t - 1;
	if (blocked_reflect && blocked && (t <= 1))
	{
		x = xprevious;
		y = yprevious;
		h_speed = -6 * dir;
		v_speed = -3;
		if (dash)
		{
			grav = 0.25;
		}
	}
}
*/