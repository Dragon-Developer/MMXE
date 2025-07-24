function GameServer(_port) : NET_TcpServer(_port) constructor {
//	self.enableConnectionMode();
	global.local_player_index = 0;
	global.game.add_local_players([0]);
	global.game.inputs.setTotalPlayers(3);
	global.game.add_event_listener("input_local", function(_data) {
		inputRpc.sendInput(0, _data.frame, _data.inputs[0]);
	});
	pingRpc = new PingRpc();
	inputRpc = new InputRpc(true);
	pingRpc.onPingReceived = function(_ping) {
		global.game.on_ping_received(_ping);
	}
	self.setEvent("connected", function(_client) {
		log(_client)
		pingRpc.sendPing(_client.socket);
	});
	self.setEvent("error", function(_err) {
		show_debug_message(_err);
	});
	self.start();
}