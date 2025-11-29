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
	
	self.player_times = [];
	self.plaer_names = [];
	self.player_money = [];
	
	rpc.registerHandler("set_player_id", function(_id) {
		//global.game.inputs.setTotalPlayers(_id.players);
		log(string(global.game.inputs.totalPlayers) + " is the player count for " + string(_id._id))
		log(string(_id._id) +  " got its id set")
		input_source_set(INPUT_KEYBOARD, _id._id);
		global.local_player_index = _id._id;
		rpc.sendNotification("add_name", { name: global.settings.online_username, id: _id._id}, undefined);
	});
	rpc.registerHandler("game_start", function(_params) {
		var players = _params.players;
		var totalPlayers = array_length(players);
		self.player_names = _params.names;
		global.game.add_local_players([global.local_player_index]);
		global.game.inputs.setTotalPlayers(totalPlayers);
		//global.game.add_local_players([global.local]);
		global.gui.lobbyMenuContainer.setEnabled(false);	
		global.gui.startMultiplayerLobby(_params.room);
		self.started = true;
			global.client.player_times = array_create(array_length(global.game.__local_players) + 1,-1);
			global.client.player_money = array_create(array_length(global.game.__local_players) + 1,0);
	});
	
	rpc.registerHandler("race_ready", function(_map) {
		self.players_ready = array_create(array_length(global.game.__local_players) + 1,-1);
		room_goto(_map.map)
		instance_create_depth(0,0,-1235,obj_race_handler)
	});
	
	//dark may complain but it works so he can shove it up his ass for the moment
	rpc.registerHandler("set_player_position", function(_params) {
		with(obj_player){
			if(_params.id == components.get(ComponentPlayerInput).get_player_index() && _params.id != global.local_player_index){
				x = _params.x;
				y = _params.y;
			}
		}
	});
	
	rpc.registerHandler("race_time_submitted", function(_params) {
		self.player_times[_params.id] = _params.time;
		self.player_money[_params.id] += _params.time / 256;
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
	
	self.setEvent("connected", function() {
		log("this client was connected")
		global.gui.playOnlineContainer.setEnabled(false);
		global.gui.lobbyMenuContainer.setEnabled(false);	
		self.pingRpc.sendPing();
	});
	self.setEvent("error", function(_err) {
		show_debug_message(_err);
	});
	
	//race functions. could be moved into another object but thats a future forte problem
	self.check_into_race = function(_ready){
		rpc.sendNotification("check_into_race", { id: global.local_player_index, ready: _ready}, undefined);
	}
	self.upload_time = function(_time, _index = 0){
		self.player_times[_index] = _time;
		self.player_money[_index] += _time / 256;
		rpc.sendNotification("race_time_submitted", {time: _time, id: _index}, undefined);
	}
	self.request_purchase = function(_money, _function, _index = 0, _args = []){
		rpc.sendNotification("request_purchase", {money: _money, id: _index, func: _function, args: _args}, undefined);
	}
	self.update_position = function(_x, _y){
		rpc.sendNotification("set_player_position", {x: _x, y: _y, id: global.local_player_index}, undefined);
	}
	
	self.start();
}