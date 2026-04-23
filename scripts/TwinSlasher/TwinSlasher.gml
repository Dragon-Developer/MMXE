// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function TwinSlasher() : ProjectileWeapon() constructor{
	self.data = [TwinSlasherUpData,TwinSlasherUpData,TwinSlasherUpData,TwinSlasherUpChargedData,TwinSlasherUpChargedData];
	self.charge_limit = 3;

	self.title = "TWIN S.";
	self.description = "FIRES MULTIPLE CUTTING BLASTS"
	
	self.weapon_palette = [
		#403840,//Blue Armor Bits
		#606068,
		#808080,
		#704008,//teal bits
		#c86008,
		#e8c808
	];
}

function TwinSlasherUpData() : ProjectileData() constructor{
	self.comboiness = 6;
	
	self.shot_limit = 5;
	self.damage = 2;
	self.animation = "twin_slasher_charged_middle";
	self.vdir = 1;
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_1");
		PROJECTILES.create_projectile(_inst.x, _inst.y, dir, TwinSlasherDownData, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
	}
	self.step = function(_inst){
		
		_inst.x += 7 * dir;
		_inst.y += 5 * vdir * -1;
		
		if CURRENT_FRAME mod 2 == 0 
			WORLD.spawn_particle(new TwinSlasherParticle(_inst.x, _inst.y, dir, vdir))
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function TwinSlasherDownData() : TwinSlasherUpData() constructor{
	self.comboiness = 6;
	self.vdir = -1;
	
	self.create = function(_inst){
	}
}

function TwinSlasherParticle(_x, _y, _dir, _vdir) : ParticleBase() constructor{
	self.sprite = "twin_slasher";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 1;
	self.frame = 0;
	self.frame_max = 5;
	self.dir = _dir;
	self.vdir = _vdir;
}

function TwinSlasherUpChargedData() : ProjectileData() constructor{
	self.comboiness = -1;
	
	self.shot_limit = 20;
	self.damage = 5;
	self.animation = "twin_slasher_charged_outer";
	self.vdir = 1;
	
	self.hspd = 8;
	self.vspd = 4;
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_3");
		//PROJECTILES.create_projectile(_inst.x, _inst.y, dir, TwinSlasherDownData, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
		
		var _angle = new Vec2(0,12);
		
		_angle = _angle.rotate(-20);
		hspd = _angle.x;
		vspd = _angle.y;
		_angle = _angle.rotate(-20);
		
		var _shot = PROJECTILES.create_projectile(_inst.x, _inst.y, dir, TwinSlasherDownChargedData, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
		_shot.code.hspd = _angle.x;
		_shot.code.vspd = _angle.y;
		_angle = _angle.rotate(-20);
		
		_shot = PROJECTILES.create_projectile(_inst.x, _inst.y, dir, TwinSlasherDownChargedDataB, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
		_shot.code.hspd = _angle.x;
		_shot.code.vspd = _angle.y;
		_angle = _angle.rotate(-20);
		
		_shot = PROJECTILES.create_projectile(_inst.x, _inst.y, dir, TwinSlasherDownChargedDataB, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
		_shot.code.hspd = _angle.x;
		_shot.code.vspd = _angle.y;
		_angle = _angle.rotate(-20);
		
		_shot = PROJECTILES.create_projectile(_inst.x, _inst.y, dir, TwinSlasherDownChargedDataC, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
		_shot.code.hspd = _angle.x;
		_shot.code.vspd = _angle.y;
		_angle = _angle.rotate(-20);
		
		_shot = PROJECTILES.create_projectile(_inst.x, _inst.y, dir, TwinSlasherDownChargedDataC, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
		_shot.code.hspd = _angle.x;
		_shot.code.vspd = _angle.y;
		_angle = _angle.rotate(-20);
		
		_shot = PROJECTILES.create_projectile(_inst.x, _inst.y, dir, TwinSlasherDownChargedDataD, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
		_shot.code.hspd = _angle.x;
		_shot.code.vspd = _angle.y;
		_angle = _angle.rotate(-20);
		
		_shot = PROJECTILES.create_projectile(_inst.x, _inst.y, dir, TwinSlasherDownChargedDataD, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
		_shot.code.hspd = _angle.x;
		_shot.code.vspd = _angle.y;
		_angle = _angle.rotate(-20);
	}
	self.step = function(_inst){
		
		_inst.x += hspd * dir;
		_inst.y += vspd * vdir * -1;
		
		if CURRENT_FRAME mod 2 == 0 
			WORLD.spawn_particle(new TwinSlasherParticle(_inst.x, _inst.y, dir, vdir))
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function TwinSlasherDownChargedData() : TwinSlasherUpChargedData() constructor{
	self.animation = "twin_slasher_charged_outer";
	self.create = function(_inst){
	}
}

function TwinSlasherDownChargedDataB() : TwinSlasherDownChargedData() constructor{
	self.animation = "twin_slasher";
}

function TwinSlasherDownChargedDataC() : TwinSlasherDownChargedData() constructor{
	self.animation = "twin_slasher_down";
}

function TwinSlasherDownChargedDataD() : TwinSlasherDownChargedData() constructor{
	self.animation = "twin_slasher_charged_outer_down";
}