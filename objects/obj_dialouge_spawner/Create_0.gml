event_inherited();
entity_object = obj_dialouge;
dialouge = [
		{   sentence : "spawner error!",
			mugshot_left : X_Mugshot_Happy1,
			mugshot_right : X_Mugshot1,
			focus : "left"
		}
	];
left_mugshot = X_Mugshot_Angy1;
right_mugshot = X_Mugshot_Angy1;
on_spawn = function(_player) {
	_player.components.get(ComponentDialouge).set_dialouge(dialouge, left_mugshot, right_mugshot);
	_player.components.get(ComponentPlayerInput).set_player_index(global.local_player_index);
	_player.components.publish("change_dialouge",dialouge);
}
