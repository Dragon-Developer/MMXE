WORLD = ENTITIES.create_instance(obj_world);

var _player = ENTITIES.create_instance(obj_player);
_player.components.get(EntityComponentAnimation).set_subdirectories(["/normal", "/armor/x2"]);
_player.components.publish("character_set", "x");
_player.x = 160;
_player.y = 1800;

var _camera = ENTITIES.create_instance(obj_camera);
_camera.components.publish("target_set", _player);