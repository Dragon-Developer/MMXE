event_inherited();
entity_object = par_enemy;
enemyData = BaseEnemy;

on_spawn = function(_player) {
	_player.components.publish("character_set", "enemy");
	//might get a base enemies folder. the subdirectories could be the different enemies
	_player.components.get(ComponentAnimation).set_subdirectories(["/normal"]);
	_player.components.get(ComponentAnimation).max_queue_size = 0;
	_player.components.get(ComponentPhysics).grav = new Vec2(0, 0);
}

alarm[0] = 2;