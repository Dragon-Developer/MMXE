function GameServer(_port) : NET_TcpServer(_port) constructor {
//	self.enableConnectionMode();

	self.players_ready = [];
	self.player_times = [];

	global.local_player_index = 0;
	global.game.add_local_players([0]);
	global.game.inputs.setTotalPlayers(3);
	global.game.add_event_listener("input_local", function(_data) {
		inputRpc.sendInput(0, _data.frame, _data.inputs[0]);
	});
	pingRpc = new PingRpc();
	inputRpc = new InputRpc(true);
	self.playerRpc = new PlayerRpc(true);
	pingRpc.onPingReceived = function(_ping) {
		global.game.on_ping_received(_ping);
	}
	self.setEvent("connected", function(_client) {
		log("client connected")
		pingRpc.sendPing(_client.socket);
	});
	self.setEvent("error", function(_err) {
		show_debug_message(_err);
	});
	
	self.rpc.registerHandler("check_into_race", function(_params) {
		self.players_ready[_params.id] = _params.ready;
		self.check_if_race_is_ready();
	});
	
	self.check_if_race_is_ready = function(){
		if(!array_contains(self.players_ready, -1)){
			
			var _map = players_ready[random_range(0,array_length(players_ready) - 1)];
			
			rpc.sendNotification("race_ready", {map: _map}, getAllSockets());
			log("RACE READY")
			self.players_ready = array_create(array_length(global.server.getAllSockets()) + 1,-1);
			room_goto(_map)
			instance_create_depth(0,0,-1235,obj_race_handler)
		} else {
			
		}
	}
	
	self.check_into_race = function(_ready){
		self.players_ready[0] = _ready;
		self.check_if_race_is_ready();
	}
	
	self.start();
}