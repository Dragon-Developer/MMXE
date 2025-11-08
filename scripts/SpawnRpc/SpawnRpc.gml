function SpawnRpc(_is_server = false) constructor {
	socket = other;
	isServer = _is_server;
	
	self.packet_redundancy_level = global.server_settings.client_data.ping_rate;
	
	self.register = function() {
		self.socket.rpc.registerHandler("spawn_entity", function(_params) {
			return _params;
		});
	}
	
	self.register();
}