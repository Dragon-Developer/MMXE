function EnemyShootableWall() : BaseEnemy() constructor{
	self.health = 16;
	self.maxHealth = 16;
	
	self.weaknesses = [{projectile: xBuster14Data, rate: 40}]
	
	self.sprite = "brittle_metal"
	
	self.hitbox_scale = new Vec2(24,48);
	
	self.init = function(_self){
		self.collision = instance_create_depth(_self.x - 16, _self.y - 32, 0, obj_square_16)
		collision.image_xscale = 2;
		collision.image_yscale = 4;
	}
	
	self.step = function(){
		if (self.health <= maxHealth && (CURRENT_FRAME mod 3) == 1)
			self.health++;
			
			
	}

	self.destroy = function(){
		instance_destroy(collision)
	}
}