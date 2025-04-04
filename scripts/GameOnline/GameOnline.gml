function GameOnline() : NET_GameRollback() constructor {
	self.set_game_loop(new GameLoop());
	self.set_input_manager(new GameInput());
}