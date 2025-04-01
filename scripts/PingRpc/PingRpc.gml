function PingRpc() constructor {
	self.socket = other;
	self.ping = 0;
	self.register = function() {
		self.socket.rpc.registerHandler("ping", function(_params) {
			return _params;
		});
	}
	self.onPingReceived = function(_ping) { };
	self.sendPing = function(_socket = undefined) {
		self._socket = _socket;
		// Wait 1 second to send ping
		call = call_later(1, time_source_units_seconds, function() {
			socket.rpc.sendRequest("ping", current_time, _socket)
				.onCallback(function(_result) {
					var _ping = current_time - _result;
					self.ping = _ping;
					self.onPingReceived(self.ping);
				})
				.onError(function(_error) {
					show_debug_message(_error);
					show_debug_message($"Error {_error.code}: {_error.message}");	
				})
				.onFinally(function() {
					self.sendPing(_socket);
				});
		});
	}
	self.register();
}