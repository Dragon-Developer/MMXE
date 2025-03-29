function NET_Socket(_type, _ip, _port) constructor {
	self.connected = false;
	self.events = {};
	self.socket = -1;
	self.type = _type;
	self.ip = _ip;
	self.port = _port;
	self.rpc = new NET_Rpc();
	self.network = new NET_Network();
	self.rpc.setNetwork(self.network);
	self.connect = function() {
		network_connect_async(self.socket, self.ip, self.port);	
	}
	static setLocalServer = function(_server) {
		_server.addLocalClient(self);
		self.network.setLocalServer(_server);
	}
	static enableConnectionMode = function() {}
	static setType = function(_type) {
		self.type = _type;	
	}
	static setEvent = function(_event, _method) {
		self.events[$ _event] = _method;
	}
	static triggerEvent = function(_event, _params) {
		if (variable_struct_exists(self.events, _event)) {
			self.events[$ _event](_params);	
		}
	}
	static start = function() {
		self.socket = network_create_socket(self.type);
		self.network.setDefaultSocket(self.socket);
		self.network.setDefaultUDP(self.ip, self.port);
		self.network.setType(self.type);
		self.connect();
		NET_Wrapper.add(self);
	}
	static step = function() {
		self.triggerEvent("step");
		self.network.step();	
	}
	static step_end = function() {
		self.triggerEvent("step_end");
	}
	static destroy = function() {
		network_destroy(self.socket);
		NET_Wrapper.remove(self);
	}
	static onAsyncNetworking = function(_async_load) {
		var _socket = _async_load[? "socket"];
		var _type = _async_load[? "type"];
		var _id = _async_load[? "id"];
		// Ignore if it's not from this client socket
		if (_id != self.socket) return;
		// Handle connection
		if (_type == network_type_non_blocking_connect) {
			var _succeded = _async_load[? "succeeded"];
			if (_succeded) {
				self.connected = true;
				self.triggerEvent("connected");
			} else {
				self.triggerEvent("error");
			}
		}
		// Handle data packets using RPC
		else if (_type == network_type_data) {
			var _buffer = _async_load[? "buffer"];
			try {
				self.network.processBuffer(_buffer, _id);
			} catch (_error) {
				self.triggerEvent("error", _error);
			}
		}	
	}
	self.network.onMessage = function(_buffer, _id) {
		var _json = self.network.readBufferText(_buffer);
		var _data = json_parse(_json);
		self.triggerEvent("message", {
			data: _data,
			socket: _id
		});	
	}
	self.setEvent("message", function(_msg) {
		self.rpc.handleMessageFromSocket(_msg.data, _msg.socket);
	});
}
function NET_SocketRAW(_type, _ip, _port) : NET_Socket(_type, _ip, _port) constructor {
	self.connect = function() {
		self.network.setRAW(true);
		network_connect_raw_async(self.socket, self.ip, self.port);	
	}
}
