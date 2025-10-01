function InputRpc(_is_server = false) constructor {
	socket = other;
	isServer = _is_server;
	self.register = function() {
		socket.rpc.registerHandler("input_update", function(_params, _client) {
			var _player_id = (isServer) ? 1 : _params.id;
			var _frame = _params.frame;
			var _input = _params.input;
			global.game.add_input(_frame, _player_id, _input);
		});
	}
	self.sendInput = function(_id, _frame, _input) {
		var _sockets = (isServer) ? socket.getAllSockets() : 0;
		socket.rpc.sendNotification("input_update", {
			id: _id,
			frame: _frame,
			input: _input
		}, _sockets);
	}
	
	self.register();
}