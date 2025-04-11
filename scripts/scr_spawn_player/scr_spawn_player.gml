function scr_spawn_player(_X,_Y){
	WORLD = ENTITIES.create_instance(obj_world);

	var _player = ENTITIES.create_instance(obj_player);
	_player.components.get(ComponentAnimation).set_subdirectories(["/normal", "/armor/x2"]);
	_player.components.publish("character_set", "x");
	_player.x = _X;
	_player.y = _Y;

	var _camera = ENTITIES.create_instance(obj_camera);
	_camera.components.publish("target_set", _player);
}