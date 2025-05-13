event_inherited();
entity_object = obj_player;
spawn_times = GAME.inputs.getTotalPlayers();
current_spawn = 0;
on_spawn = function(_player) {
	_player.components.get(ComponentAnimation).set_subdirectories(
	["/normal", "/armor/x2/legs", "/armor/x1/helm"]);
	_player.components.get(ComponentPlayerInput).set_player_index(current_spawn);
	_player.components.publish("character_set", "x");
	//_player.components.publish("armor_set",
	//["x2_legs", "x1_helm"]);
	
	if (current_spawn == global.local_player_index) {
		var _camera = ENTITIES.create_instance(obj_camera);
		_camera.components.publish("target_set", _player);	
		_player.components.get(ComponentAnimation).max_queue_size = 0;
	}
	current_spawn++;
}