if dir == "right"
	have_player_move(["r", 1000, "Maverick dead"], other)
else 
	have_player_move(["l", 1000, "Maverick dead"], other)

room_transition_to(rm, "standard", 30)
global.checkpoint_id = checkpoint_id
global.force_idle = true;