event_inherited();
entity_object = obj_armor_select;
on_spawn = function(_player) {
	_player.components.get(ComponentPlayerInput).set_player_index(global.local_player_index);
}
