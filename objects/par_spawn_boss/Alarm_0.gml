on_spawn = function(_shot) {
	log( enemyData.image_folder)
	log("syaidfiokfgbhiniubngfibnsdgfiubgnhsfdiubnfgdiubgytdsfiuybtgfdsyubitkgfsdibtuyfgsdibtuagdobinydfnbadsf")
	_shot.components.publish("character_set", enemyData.image_folder);
	_shot.components.get(ComponentAnimation).set_subdirectories(enemyData.subdirectories);
	_shot.components.get(ComponentAnimation).max_queue_size = 0;
	_shot.components.get(ComponentPhysics).grav = new Vec2(0, 0);
	_shot.components.get(ComponentBoss).EnemyEnum = enemyData;
	_shot.components.publish("enemy_data_set", enemyData);
	//enemyData.init(_shot.components.get(ComponentBoss))
}
repeat(spawn_times) {
	spawn();
}
instance_destroy();