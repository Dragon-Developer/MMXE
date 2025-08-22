self.spawn_boss = function(){
	var _boss = ENTITIES.create_instance(par_boss);
	_boss.x = x;
	_boss.y = y;
	//_boss.components.get(ComponentBoss).boss_data = self.boss;
	_boss.components.publish("character_set", "x");
	_boss.components.get(ComponentAnimation).set_subdirectories(["/normal"]);
	_boss.components.get(ComponentAnimation).max_queue_size = 0;
	_boss.components.get(ComponentPhysics).grav = new Vec2(0, 0);
	_boss.components.get(ComponentBoss).boss_data = boss;
	_boss.components.publish("enemy_data_set", boss);
}

self.boss = FlameStagBoss;