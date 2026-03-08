// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ElectricWeb() : ProjectileWeapon() constructor{
	self.data = [ElectricWebPreShot,ElectricWebPreShot,ElectricWebPreShot,ElectricWebFullChargePreShot,ElectricWebFullChargePreShot];
	self.charge_limit = 3;

	self.title = "L. WEB";
	self.description = "MAKES A SURFACE TO JUMP OFF OF"
	
	self.weapon_palette = [
		#a75229,//Blue Armor Bits
		#e88840,
		#f8e890,
		#383038,//teal bits
		#505058,
		#788199
	];
}

function ElectricWebPreShot() : ProjectileData() constructor{
	self.comboiness = 6;
	
	self.shot_limit = 1;
	self.shot_time = CURRENT_FRAME + 25;
	self.animation = "electric_web";
	
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
			
		if(shot_time <= CURRENT_FRAME){
			PROJECTILES.create_projectile(_inst.x, _inst.y, dir, ElectricWebExtendedShot, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
		}
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function ElectricWebFullChargePreShot() : ElectricWebPreShot() constructor{
	self.comboiness = 8;
	self.shot_time = CURRENT_FRAME + 10;
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 7;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 8;
		if(!is_undefined(_inst))
			_inst.x += _hspd * self.dir;
			
		if(shot_time <= CURRENT_FRAME){
			PROJECTILES.create_projectile(_inst.x, _inst.y + 40, dir, ElectricWebChargedExtendedShot, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			PROJECTILES.create_projectile(_inst.x, _inst.y, dir, ElectricWebChargedExtendedShot, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			PROJECTILES.create_projectile(_inst.x, _inst.y - 40, dir, ElectricWebChargedExtendedShot, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			
			PROJECTILES.create_projectile(_inst.x + 16 * dir, _inst.y + 20, dir, ElectricWebDummyShot, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			PROJECTILES.create_projectile(_inst.x + 16 * dir, _inst.y - 20, dir, ElectricWebDummyShot, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			
			PROJECTILES.create_projectile(_inst.x - 16 * dir, _inst.y + 20, dir, ElectricWebDummyShot, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			PROJECTILES.create_projectile(_inst.x - 16 * dir, _inst.y - 20, dir, ElectricWebDummyShot, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
		}
	}
}

function ElectricWebExtendedShot() : ProjectileData() constructor{
	self.comboiness = 7;
	
	self.shot_limit = 2;
	self.shot_time = CURRENT_FRAME + 130;
	self.animation = "electric_web_extended";
	self.collision = undefined;
	
	self.create = function(_inst){
		collision = instance_create_depth(floor(_inst.x) - 2, floor(_inst.y) - 20, 0, obj_square_16)
		
		collision.image_yscale = 2.5;
		collision.image_xscale = 0.25;
		
		WORLD.play_sound("shoot_2");
	}
	self.step = function(_inst){
		if(shot_time <= CURRENT_FRAME){
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
		}
	}
	self.destroy = function(_inst){
		instance_destroy(collision)
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function ElectricWebChargedExtendedShot() : ProjectileData() constructor{
	self.comboiness = 7;
	
	self.shot_limit = 2;
	self.shot_time = CURRENT_FRAME + 360;
	self.animation = "electric_web_extended";
	self.collision = undefined;
	
	self.create = function(_inst){
		collision = instance_create_depth(floor(_inst.x) - 2, floor(_inst.y) - 20, 0, obj_square_16)
		
		collision.image_yscale = 2.5;
		collision.image_xscale = 0.25;
		
		WORLD.play_sound("shoot_2");
	}
	self.step = function(_inst){
		if(shot_time <= CURRENT_FRAME){
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
		}
	}
	self.destroy = function(_inst){
		instance_destroy(collision)
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function ElectricWebDummyShot() : ProjectileData() constructor{
	self.comboiness = 7;
	
	self.shot_limit = 2;
	self.shot_time = CURRENT_FRAME + 360;
	self.animation = "electric_web_extended";
	self.collision = undefined;
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_2");
	}
	self.step = function(_inst){
		if(shot_time <= CURRENT_FRAME){
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
		}
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}