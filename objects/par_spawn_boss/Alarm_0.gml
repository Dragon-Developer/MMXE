on_spawn = function(_shot) {
	_shot.components.publish("character_set", "x");
	_shot.components.get(ComponentAnimation).set_subdirectories(["/normal"]);
	_shot.components.get(ComponentAnimation).max_queue_size = 0;
	_shot.components.get(ComponentPhysics).grav = new Vec2(0, 0);
	_shot.components.get(ComponentBoss).EnemyEnum = enemyData;
	_shot.components.publish("enemy_data_set", enemyData);
}
repeat(spawn_times) {
	spawn();
}
instance_destroy();