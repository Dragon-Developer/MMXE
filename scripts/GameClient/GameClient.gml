function GameClient(_ip, _port) : NET_TcpSocket(_ip, _port) constructor {
	//self.enableConnectionMode();
	input_source_set(INPUT_KEYBOARD, 1);
	global.local_player_index = 1;
	global.game.add_event_listener("input_local", function(_data) {
		//log("my id is " + string(global.local_player_index) + " and my inputs are " + string(_data.inputs[0]))
		self.inputRpc.sendInput(global.local_player_index, _data.frame, _data.inputs[0]);
		//log(string(global.local_player_index)+" updated its inputs")
	});
	self.started = false;
	self.inputRpc = new InputRpc(false);
	self.pingRpc = new PingRpc();
	self.playerRpc = new PlayerRpc(false);
	self.pingRpc.onPingReceived = function(_ping) {
		global.game.on_ping_received(_ping);
	}
	rpc.registerHandler("set_player_id", function(_id) {
		//global.game.inputs.setTotalPlayers(_id.players);
		log(string(global.game.inputs.totalPlayers) + " is the player count for " + string(_id._id))
		log(string(_id._id) +  " got its id set")
		input_source_set(INPUT_KEYBOARD, _id._id);
		global.local_player_index = _id._id;
	});
	rpc.registerHandler("game_start", function(_params) {
		var players = _params.players;
		var totalPlayers = array_length(players);
		global.game.add_local_players([global.local_player_index]);
		global.game.inputs.setTotalPlayers(totalPlayers);
		//global.game.add_local_players([global.local]);
		global.gui.lobbyMenuContainer.setEnabled(false);	
		global.gui.startMultiplayerLobby(_params.room);
		self.started = true;
	});
	
	self.setEvent("connected", function() {
		log("this client was connected")
		global.gui.playOnlineContainer.setEnabled(false);
		global.gui.lobbyMenuContainer.setEnabled(false);	
		self.pingRpc.sendPing();
	});
	self.setEvent("error", function(_err) {
		show_debug_message(_err);
	});
	self.start();
}