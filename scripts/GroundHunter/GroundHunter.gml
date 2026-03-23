// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GroundHunter() : ProjectileWeapon() constructor{
	self.data = [GroundHunterData,GroundHunterData,GroundHunterData,GroundHunterChargedData,GroundHunterChargedData];
	self.charge_limit = 3;

	self.title = "G. HUNTER";
	self.description = "GROUND CRAWLER THAT DIES ON WALLS"
	
	self.weapon_palette = [
		#882840,//Blue Armor Bits
		#d04070,
		#f878c0,
		#205060,//teal bits
		#2080b0,
		#20d0f0
	];
}

function GroundHunterData() : ProjectileData() constructor{
	self.comboiness = 6;
	
	self.shot_limit = 5;
	self.damage = 3;
	self.animation = "ground_hunter";
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_2");
		_inst.y -= _inst.y mod 4
	}
	self.step = function(_inst){
		//if it doesnt detect the ground it goes down. always moves forward until it cant
		
		_inst.x += self.dir * 3;
		
		if(!instance_position(_inst.x, _inst.y + 4, obj_square_16))
			_inst.y += 4;
			
		if CURRENT_FRAME mod 25 == 0 
			WORLD.spawn_particle(new DashParticle(_inst.x - 16 * dir, _inst.y + 8, dir))
			
		if(instance_position(_inst.x + 8 * dir, _inst.y - 6, obj_square_16))
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function GroundHunterChargedData() : ProjectileData() constructor{
	self.comboiness = 6;
	
	self.shot_limit = 34;
	self.damage = 7;
	self.super_piercing = true;
	self.animation = "ground_hunter";
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_2");
		dir *= 2;
	}
	self.step = function(_inst){
		//if it doesnt detect the ground it goes down. always moves forward until it cant
		
		_inst.x += self.dir * 2;
		
		if(!instance_position(_inst.x, _inst.y + 2, obj_square_16))
			_inst.y += 2;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}