global_init();

var _player = ENTITIES.create_instance(obj_player);
_player.components.publish("character_set", "x");
_player.components.publish("animation_play", { name: "idle" });
_player.x = 160;
_player.y = 128;
