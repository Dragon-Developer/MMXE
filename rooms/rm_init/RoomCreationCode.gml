global_init();

if(true){// put true to spawn here, and false to spawn in gate 2
	scr_spawn_player(160,140);
} else {
	room_goto(rm_gate_2);
}