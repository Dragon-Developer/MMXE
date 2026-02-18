event_inherited();
entity_object = obj_gravity_button;
on_spawn = function(_player) {
	_player.components.get(ComponentAnimation).set_subdirectories(["/normal"]);
	_player.components.publish("character_set", "x");
	_player.components.publish("animation_play", "idle");
}