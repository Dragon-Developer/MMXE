function GameServer(_port) : NET_TcpServer(_port) constructor {
//	self.enableConnectionMode();

	self.players_ready = [];
	self.player_times = [];
	self.player_money = [];
	self.player_names = [];

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
	
	global.gui.lobbyMenuContainer.playercount.children = [];
	global.gui.lobbyMenuContainer.playercount.setText("Playercount: " + string( array_length(getAllSockets())));
	
	self.setEvent("connected", function(_client) {
		log("client connected")
		global.gui.lobbyMenuContainer.playercount.children = [];
		global.gui.lobbyMenuContainer.playercount.setText("Playercount: " + string( array_length(getAllSockets())));
		audio_play_sound(audio_create_stream(working_directory + "sounds/player_joined.ogg"), 1, false, 0.75, 0)
		pingRpc.sendPing(_client.socket);
	});
	self.setEvent("error", function(_err) {
		log("err!");
		log(_err);
	});
	
	self.rpc.registerHandler("check_into_race", function(_params) {
		self.players_ready[_params.id] = _params.ready;
		self.check_if_race_is_ready();
	});
	
	rpc.registerHandler("race_time_submitted", function(_params) {
		self.player_times[_params.id] = _params.time;
		self.player_money[_params.id] = _params.time;
		log(self.player_money[_params.id])
		log("money money money")
	});
	
	rpc.registerHandler("request_purchase", function(_params) {
		if(_params.money <= self.player_money[_params.id]){
			self.player_money[_params.id] -= _params.money;
			rpc.sendNotification("run_function_on_player", _params, getAllSockets());
		}
	});
	
	rpc.registerHandler("run_function_on_player", function(_params) {
		with(obj_player){
			var _args = [];
			if(variable_struct_exists(_params, "args"))
				_args = _params.args
				
			if(components.get(ComponentPlayerInput).get_player_index() == _params.id)
				script_execute_ext(_params.func, _args)
		}
	});
	
	self.rpc.registerHandler("add_name", function(_params) {
		self.player_names[_params.id] = _params.name;
	});
	
	self.rpc.registerHandler("set_player_position", function(_params) {
		rpc.sendNotification("set_player_position", _params, getAllSockets());
		with(obj_player){
			if(_params.id == components.get(ComponentPlayerInput).get_player_index()){
				x = _params.x;
				y = _params.y;
			}
		}
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
	
	self.upload_time = function(_time){
		self.player_times[0] = _time;
		self.player_money[0] += _time;
		rpc.sendNotification("race_time_submitted", {time: _time, id: 0}, getAllSockets());
	}
	
	self.check_into_race = function(_ready){
		self.players_ready[0] = _ready;
		self.check_if_race_is_ready();
	}
	self.request_purchase = function(_money, _function, _index = 0, _args = []){
		if(_money <= self.player_money[_index]){
			rpc.sendNotification("run_function_on_player", {money: _money, id: _index, func: _function, args: _args}, getAllSockets());
		
			self.player_money[_index] -= _money;
			
			with(obj_player){
				if(components.get(ComponentPlayerInput).get_player_index() == _index)
					script_execute_ext(_function, _args)
			}
		}
	}
	
	self.start();
}