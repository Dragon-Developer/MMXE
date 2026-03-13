event_inherited();
entity_object = obj_score_showcase;
on_spawn = function(_player) {
	_player.components.get(ComponentPlayerInput).set_player_index(0);
}
global_prepare_application(MENU_W, MENU_H);