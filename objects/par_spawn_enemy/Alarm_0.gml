on_spawn = function(_shot) {
	_shot.components.publish("character_set", "enemy");
	//might get a base enemies folder. the subdirectories could be the different enemies
	_shot.components.get(ComponentAnimationShadered).set_subdirectories(["/normal"]);
	_shot.components.get(ComponentPhysics).grav = new Vec2(0, 0);
	_shot.components.get(ComponentDamageable).projectile_tags = ["enemy"]
	_shot.components.get(ComponentEnemy).EnemyEnum = enemyData;
	_shot.components.publish("enemy_data_set", enemyData);
}
repeat(spawn_times) {
	spawn();
}
instance_destroy();