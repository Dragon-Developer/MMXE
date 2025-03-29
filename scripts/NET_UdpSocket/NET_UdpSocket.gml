function NET_UdpSocket(_ip, _port) 
: NET_Socket(network_socket_udp, _ip, _port) constructor {
	self.connectionMode = false;
	self.network.onMessage = function(_buffer, _id) {
		var _json = network.readBufferText(_buffer);
		var _data = json_parse(_json);
		self.triggerEvent("message", {
			data: _data
		});	
	}
	self.onAsyncNetworking = function(_async_load) {
		var _type = _async_load[? "type"];
		var _id = _async_load[? "id"];
		var _buffer = _async_load[? "buffer"];
		if (_id != self.socket) return;
		if (_type != network_type_data) return;
		try {
			self.network.processBuffer(_buffer, new NET_ConnectedUdpSocket(self.ip, self.port));
		} catch (_error) {
			self.triggerEvent("error", _error);
		}	
	}
	self.enableConnectionMode = function() {
		self.connectionMode = true;
		self.connect = function() {
			self.network.sendData("connect"); 
		}
		self.setEvent("message", function(_message) {
			if (_message.data == "connected") {
				self.triggerEvent("connected");	
				return;
			}
			self.rpc.handleMessageFromSocket(_message.data);
		});
	}
}

function NET_UdpSocketRAW(_ip, _port) 
: NET_UdpSocket(_ip, _port) constructor {
	self.network.setRAW(true);
}
