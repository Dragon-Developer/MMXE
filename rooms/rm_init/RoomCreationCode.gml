global_init();

WORLD = ENTITIES.create_instance(obj_world);

var _player = ENTITIES.create_instance(obj_player);
_player.components.publish("character_set", "x");
_player.x = 160;
_player.y = 128;

var _camera = ENTITIES.create_instance(obj_camera);
_camera.components.publish("camera_target", _player);