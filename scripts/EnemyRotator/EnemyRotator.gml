function EnemyRotator() : BaseEnemy() constructor{
	self.health = 3;
	
	self.sprite = "rotator"
	
	self.step = function(_self){
		if((CURRENT_FRAME + start_time) mod 222 == 0){
			if(ENEMIES.get_animation_frame(self) == 0){
				PROJECTILES.create_projectile(_self.x + dir * 16, _self.y + 3, -1, RotatorShot, self, ["enemy"], 0);
				PROJECTILES.create_projectile(_self.x - dir * 16, _self.y + 3,  1, RotatorShot, self, ["enemy"], 0);
			} else {
				PROJECTILES.create_projectile(_self.x + dir * 13, _self.y - 1, -1, RotatorShotDiagonal, self, ["enemy"], 0);
				PROJECTILES.create_projectile(_self.x - dir * 13, _self.y - 1,  1, RotatorShotDiagonal, self, ["enemy"], 0);
			}
		}
	}
}

function RotatorShot() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 5;
	self.animation = "xShot1";
	
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
	self.animation = "xShot1";
	
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