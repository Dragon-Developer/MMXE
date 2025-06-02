function BaseEnemy() constructor{
	self.health = 1;
	self.stun_offset = 0;
	EnemyComponent = noone;
	self.init = function(){
		
	}
	
	self.step = function(_self){
		
	}
	self.setComponent = function(_self)
	{
		EnemyComponent = _self;
	}
}