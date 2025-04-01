function GameOffline() : NET_GameBase() constructor {
	self.set_game_loop(new GameLoop());
	self.set_input_manager(new GameInput());
	self.add_local_players([0]);
	self.inputs.setTotalPlayers(1);
}