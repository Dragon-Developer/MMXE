function HoloTutuorialEnemy() : BaseEnemy() constructor{
	self.health = 3;
	
	self.init = function(_self){
		self.EnemyComponent.publish("animation_play", { name: "skull_bot" });
	}
}

function HoloTutuorialEnemyWithShield() : HoloTutuorialEnemy() constructor{
	self.health = 2;
	self.init = function(_self){
		self.EnemyComponent.publish("animation_play", { name: "skull_bot_shield" });
		var _inst = self.EnemyComponent.get_instance();
		var _shield = instance_create_depth(_inst.x - 16, _inst.y - 6, 0, obj_reflect_block);
		_shield.image_xscale = 2;
		_shield.image_yscale = 0.75;
	}
}