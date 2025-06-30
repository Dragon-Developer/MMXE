event_inherited();
entity_object = obj_player;
spawn_times = GAME.inputs.getTotalPlayers();
current_spawn = 0;
on_spawn = function(_player) {
	WORLD = ENTITIES.create_instance(obj_world);
	
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
	
	if (current_spawn == global.local_player_index) {
		var _camera = ENTITIES.create_instance(obj_camera);
		_camera.components.publish("target_set", _player);	
		_player.components.get(ComponentAnimation).max_queue_size = 0;
	}
	current_spawn++;
}