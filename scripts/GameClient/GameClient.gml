function GameClient(_ip, _port) : NET_TcpSocket(_ip, _port) constructor {
	//self.enableConnectionMode();
	input_source_set(INPUT_KEYBOARD, 1);
	global.local_player_index = 1;
	global.game.add_event_listener("input_local", function(_data) {
		self.inputRpc.sendInput(0, _data.frame, _data.inputs[0]);
	});
	self.started = false;
	self.inputRpc = new InputRpc(false);
	self.pingRpc = new PingRpc();
	self.pingRpc.onPingReceived = function(_ping) {
		global.game.on_ping_received(_ping);
	}
	rpc.registerHandler("game_start", function(_params) {
		players = _params.players;
		totalPlayers = array_length(players);
		global.game.add_local_players([1]);
		global.game.inputs.setTotalPlayers(totalPlayers);
		global.gui.lobbyMenuContainer.setEnabled(false);	
		global.gui.startGame();
		self.started = true;
	});
	self.setEvent("connected", function() {
		global.gui.playOnlineContainer.setEnabled(false);
		global.gui.lobbyMenuContainer.setEnabled(false);	
		self.pingRpc.sendPing();
	});
	self.setEvent("error", function(_err) {
		show_debug_message(_err);
	});
	self.start();
}