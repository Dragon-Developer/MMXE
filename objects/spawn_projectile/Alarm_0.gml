on_spawn = function(_shot) {
	_shot.components.publish("character_set", "weapon");
	_shot.components.get(ComponentAnimation).set_subdirectories(["/normal"]);
	_shot.components.get(ComponentAnimation).max_queue_size = 0;
	_shot.components.get(ComponentProjectile).weaponData = weaponData;
	_shot.components.publish("weapon_data_set", dir);
}
repeat(spawn_times) {
	spawn();
}
instance_destroy();