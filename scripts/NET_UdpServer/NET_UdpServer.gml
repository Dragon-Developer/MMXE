function NET_UdpServer(_port) 
: NET_Server(network_socket_udp, _port, 1000) constructor {
	self.connectionMode = false;
	self.onAsyncNetworking = function(_async_load) {
		var _ip = _async_load[? "ip"];
		var _port = _async_load[? "port"];
		var _type = _async_load[? "type"];
		var _id = _async_load[? "id"];
		var _buffer = _async_load[? "buffer"];
		if (_id != socket) return;
		if (_type != network_type_data) return;
		try {
			network.processBuffer(_buffer, new NET_ConnectedUdpSocket(_ip, _port));
		} catch (_error) {
			triggerEvent("error", _error);
		}
	
	}
	static enableConnectionMode = function() {
		self.connectionMode = true;
		setEvent("message", function(_message) {
			var _socket = _message.socket;
			if (_message.data == "connect") {
				addClientBySocket(_socket);
				network.sendData("connected", _socket);
				return;
			}
			if (hasClientSocket(_socket)) {
				var _client = self.getClientBySocket(_socket);
				rpc.handleMessageFromClient(_message.data, _client);
			}
		});
	}
}
function NET_UdpServerRAW(_port) 
: NET_UdpServer(_port) constructor {
	self.network.setRAW(true);
	self.createServer = function() {
		return network_create_server_raw(type, port, maxClients);
	}
}
