event_inherited();
entity_object = obj_char_select;
on_spawn = function(_player) {
	_player.components.get(ComponentPlayerInput).set_player_index(global.local_player_index);
	
	_player.components.find("animation").set_subdirectories(
	[ "/normal"]);
	_player.components.publish("character_set", "char_select");
	_player.components.publish("animation_play", {name:"lines"});
}
