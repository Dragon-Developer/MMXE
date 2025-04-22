event_inherited();
entity_object = obj_dialouge;
dialouge = noone;
left_mugshot = X_Mugshot_Angy1;
right_mugshot = X_Mugshot_Angy1;
on_spawn = function(_player) {
	_player.components.get(ComponentDialouge).set_dialouge(dialouge, left_mugshot, right_mugshot);
	_player.components.get(ComponentPlayerInput).set_player_index(global.local_player_index);
}