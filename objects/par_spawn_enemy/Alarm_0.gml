on_spawn = function(_shot) {
	log("enemy gonna be initialized RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	_shot.components.publish("character_set", "enemy");
	//might get a base enemies folder. the subdirectories could be the different enemies
	_shot.components.get(ComponentAnimationPalette).set_subdirectories(["/normal"]);
	_shot.components.get(ComponentPhysics).grav = new Vec2(0, 0);
	_shot.components.get(ComponentDamageable).projectile_tags = ["enemy"]
	_shot.components.get(ComponentEnemy).EnemyEnum = enemyData;
	_shot.components.publish("enemy_data_set", enemyData);
	log("enemy initialized RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
}
repeat(spawn_times) {
	spawn();
}
instance_destroy();