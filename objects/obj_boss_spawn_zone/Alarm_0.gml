var _num = instance_number(obj_player)

for(var p = 0; p < _num; p++){
	player_list[p] = instance_find(obj_player, p)
}

players_accepted = array_create(_num, false);