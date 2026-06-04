function EnemyRotator() : BaseEnemy() constructor{
	self.health = 5;
	
	self.sprite = "rotator"
	
	self.hitbox_scale = new Vec2(16,20);
	self.hitbox_offset = new Vec2(0,8);
	
	self.step = function(_self){
		if(ENEMIES.get_animation_index(self) == 25 || ENEMIES.get_animation_index(self) == 245){
			
			if(ENEMIES.get_animation_frame(self) == 0){
				PROJECTILES.create_projectile(_self.x + dir * 16, _self.y + 4, -1, RotatorShot, self, ["enemy"], 0);
				PROJECTILES.create_projectile(_self.x - dir * 16, _self.y + 4,  1, RotatorShot, self, ["enemy"], 0);
				
				WORLD.spawn_particle(new DustParticle(_self.x + dir * 16 - 4, _self.y + 3, self.dir))
				WORLD.spawn_particle(new DustParticle(_self.x - dir * 16 - 4, _self.y + 3, self.dir))
			} else {
				PROJECTILES.create_projectile(_self.x + dir * 13, _self.y - 1, -1, RotatorShotDiagonal, self, ["enemy"], 0);
				PROJECTILES.create_projectile(_self.x - dir * 13, _self.y - 1,  1, RotatorShotDiagonal, self, ["enemy"], 0);
				
				WORLD.spawn_particle(new DustParticle(_self.x + dir * 13 - 4, _self.y - 1, self.dir))
				WORLD.spawn_particle(new DustParticle(_self.x - dir * 13 - 4, _self.y - 1, self.dir))
			}
			
			//log(ENEMIES.get_animation_index(self))
			
			//ENEMIES.change_enemy_animation(self, "rotator")
		}
	}
}

function EnemyRotatorInverted() : BaseEnemy() constructor{
	self.health = 5;
	
	self.sprite = "rotator"
	
	self.hitbox_scale = new Vec2(16,20);
	self.hitbox_offset = new Vec2(0,-8);
	
	self.create = function(){
		self.vdir = -1;
	}
	
	self.step = function(_self){
		if(ENEMIES.get_animation_index(self) == 25 || ENEMIES.get_animation_index(self) == 245){
			
			if(ENEMIES.get_animation_frame(self) == 0){
				PROJECTILES.create_projectile(_self.x + dir * 16, _self.y - 4, -1, RotatorShot, self, ["enemy"], 0);
				PROJECTILES.create_projectile(_self.x - dir * 16, _self.y - 4,  1, RotatorShot, self, ["enemy"], 0);
				
				WORLD.spawn_particle(new DustParticle(_self.x + dir * 16 - 4, _self.y - 4, self.dir))
				WORLD.spawn_particle(new DustParticle(_self.x - dir * 16 - 4, _self.y - 4, self.dir))
			} else {
				PROJECTILES.create_projectile(_self.x + dir * 13, _self.y + 1, -1, RotatorShotDiagonalDown, self, ["enemy"], 0);
				PROJECTILES.create_projectile(_self.x - dir * 13, _self.y + 1,  1, RotatorShotDiagonalDown, self, ["enemy"], 0);
				
				WORLD.spawn_particle(new DustParticle(_self.x + dir * 13 - 4, _self.y + 1, self.dir))
				WORLD.spawn_particle(new DustParticle(_self.x - dir * 13 - 4, _self.y + 1, self.dir))
			}
			
			//log(ENEMIES.get_animation_index(self))
			
			//ENEMIES.change_enemy_animation(self, "rotator")
		}
	}
}

function RotatorShot() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 5;
	self.animation = "rotator_shot";
	
	self.create = function(_inst){
	}
	self.step = function(_inst){
		
		var _hspd = 3.5
		_inst.x += _hspd * self.dir;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function RotatorShotDiagonal() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 5;
	self.animation = "rotator_shot";
	
	self.create = function(_inst){
	}
	self.step = function(_inst){
		
		var _hspd = 3.5
		_inst.x += _hspd * self.dir;
		_inst.y -= 3.5
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function RotatorShotDiagonalDown() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 5;
	self.animation = "rotator_shot";
	
	self.create = function(_inst){
	}
	self.step = function(_inst){
		
		var _hspd = 3.5
		_inst.x += _hspd * self.dir;
		_inst.y += 3.5
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}