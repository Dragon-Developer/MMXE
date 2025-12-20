function BaseEnemy() constructor{
	self.health = 1;
	self.stun_offset = 0;
	self.contact_damage = 2;
	self.dead = false;
	
	self.sprite = "skull_bot"
	
	self.hitbox_scale = new Vec2(16,32);
	self.hitbox_offset = new Vec2(0,0);
	
	self.dir = 1;
	
	self.init = function(_self){
		
	}
	
	self.step = function(_self){
		
	}
	self.setComponent = function(_self)
	{
		EnemyComponent = _self;
	}
}