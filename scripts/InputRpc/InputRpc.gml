function InputRpc(_is_server = false) constructor {
	socket = other;
	isServer = _is_server;
	self.register = function() {
		socket.rpc.registerHandler("input_update", function(_params, _client) {
			//var _player_id = (isServer) ? 1 : _params.id;
			var _player_id = _params.id
			if (!isServer && global.local_player_index == _player_id) return;
			var _frame = _params.frame;
			var _input = _params.input;
			array_set(server.player_xs, _player_id, _params.position_x)
			//log("id: " + string(_player_id) + ", frame: " + string(_frame) + ", input: " + string(_input))
			global.game.add_input(_frame,  _player_id, _input);
			
			if(isServer)
				self.sendInput(_player_id, _frame, _input);
		});
	}
	
	self.sendInput = function(_id, _frame, _input) {
		var _sockets = (isServer) ? socket.getAllSockets() : undefined;
		
		var _position = -1;
		
		with(obj_player){
			if(components.get(ComponentPlayerInput).__player_index == global.local_player_index)
				_position = x;
		}
		
		socket.rpc.sendNotification("input_update", {
			id: _id,
			frame: _frame,
			input: _input,
			position_x: _position
		}, _sockets);
	}
	
	self.register();
}