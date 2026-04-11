event_inherited();
entity_object = obj_generic_animated_object;
animation = "idle"
character = "x"
dir = 1
on_spawn = function(_player) {
	_player.components.get(ComponentAnimationShadered).set_subdirectories(
	[ "/normal"]);
	_player.components.publish("character_set", character);
	_player.components.publish("animation_play", { name: animation});
	_player.components.publish("animation_xscale", dir);
}
