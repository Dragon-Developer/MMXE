event_inherited();
entity_object = obj_score_showcase;
on_spawn = function(_player) {
	_player.components.get(ComponentPlayerInput).set_player_index(0);
}