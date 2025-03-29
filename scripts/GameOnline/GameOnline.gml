function GameOnline() : NET_GameLockstep() constructor {
	self.set_game_loop(new GameLoop());
	self.set_input_manager(new GameInput());
}