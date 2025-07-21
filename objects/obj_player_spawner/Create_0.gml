event_inherited();
entity_object = obj_player;
spawn_times = GAME.inputs.getTotalPlayers();
current_spawn = 0;
on_spawn = function(_player) {
	
	_player.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_player.components.get(ComponentPlayerInput).set_player_index(current_spawn);
	_player.components.publish("character_set", "weapon");
	_player.components.publish("character_set", "x");
	
	//create the charge graphics and make it a child
	
	var _charge = ENTITIES.create_instance(obj_charge);
	_charge.depth = _player.depth - 1;
	_charge.components.publish("character_set", "player");
	_player.components.get(ComponentNode).add_child(_charge.components.get(ComponentNode));
	
	//set health to not 1
	_player.components.get(ComponentDamageable).set_health(12,12);
	
	if (current_spawn == global.local_player_index) {
		log("this is the player!")
		WORLD = ENTITIES.create_instance(obj_world);
		var _camera = ENTITIES.create_instance(obj_camera, x - GAME_W / 3, y - GAME_H / 2);
		_camera.components.publish("target_set", _player);	
		_camera.components.get(ComponentHealthbar).compDamageable = _player.components.get(ComponentDamageable);
		_player.components.get(ComponentAnimation).max_queue_size = 0;
	}
	current_spawn++;
}