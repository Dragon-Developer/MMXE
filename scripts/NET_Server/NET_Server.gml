function NET_Server(_type, _port, _max_clients) constructor {
	self.socket = -1;
	self.type = _type;
	self.port = _port;
	self.maxClients = _max_clients;
	self.socketIds = [];
	self.clients = new NET_Manager();
	self.network = new NET_Network();
	self.network.setType(_type);
	self.rpc = new NET_Rpc();
	self.rpc.setNetwork(self.network);
	self.nextClientId = 0;
	self.idToSocket = {};
	self.socketToId = {};
	self.events = {};
	static addLocalClient = function(_client) {
		self.network.setLocalSocket(_client);
	}
	self.createServer = function() {
		return network_create_server(self.type, self.port, self.maxClients);
	}
	self.createClient = function(_id, _socket) {
		return new NET_BaseClient(_id, _socket);
	}
	static getAllSockets = function() {
		return array_map(self.socketIds, function(_id) { return self.idToSocket[$ _id] });
	}
	static enableConnectionMode = function() {}
	static addClientBySocket = function(_socket) {
		if (variable_struct_exists(self.socketToId, _socket)) return;
		var _client = self.createClient(self.nextClientId, _socket);
		self.clients.setElement(self.nextClientId, _client);
		array_push(self.socketIds, self.nextClientId);
		self.idToSocket[$ self.nextClientId] = _socket;
		self.socketToId[$ _socket] = self.nextClientId;
		self.triggerEvent("connected", _client);
		self.nextClientId++;
	}
	static hasClientSocket = function(_socket) {
		var _id = self.socketToId[$ _socket];
		if (is_undefined(_id)) return false;
		return self.clients.hasElement(_id);	
	}
	static hasClient = function(_id) {
		return self.clients.hasElement(_id);	
	}
	static getClientBySocket = function(_socket) {
		var _id = self.socketToId[$ _socket];
		return self.clients.getElement(_id);	
	}
	static getClient = function(_id) {
		return self.clients.getElement(_id);	
	}
	static removeClientBySocket = function(_socket) {
		var _id = self.socketToId[$ _socket];
		self.removeClient(_id);
	}
	static removeClient = function(_id) {
		if (is_undefined(_id)) return;
		if (!self.clients.hasElement(_id)) return;
		var _client = self.clients.getElement(_id);
		self.triggerEvent("disconnected", _client);
		self.clients.removeElement(_id);
		var _socket = self.idToSocket[$ _id];
		struct_remove(self.idToSocket, _id);
		struct_remove(self.socketToId, _socket);
		var _index = array_get_index(self.socketIds, _socket);
		if (_index == -1) return;
		array_delete(self.socketIds, _index, 1);
	}
	static destroy = function() {
		network_destroy(self.socket);
		self.clients.clearAll();
		self.socketIds = [];
		NET_Wrapper.remove(self);
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
		self.socket = self.createServer();
		self.network.setDefaultSocket(self.socket);
		NET_Wrapper.add(self);
	}
	static step = function() {
		self.triggerEvent("step");
		self.network.step();	
	}
	static step_end = function() {
		self.triggerEvent("step_end");
	}
	static onAsyncNetworking = function(_async_load) {
		var _socket = _async_load[? "socket"];
		var _type = _async_load[? "type"];
		var _id = _async_load[? "id"];
		// Handle connection and disconnection
		if (_id == self.socket) {
			switch (_type) {
				case network_type_connect:
					self.addClientBySocket(_socket);
					break;
		
				case network_type_disconnect:
					self.removeClientBySocket(_socket);
					break;
			}
		}
		// Handle data packets using RPC
		else if (_type == network_type_data && self.hasClientSocket(_id)) {
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
		var _client = self.getClientBySocket(_msg.socket);
		self.rpc.handleMessageFromClient(_msg.data, _client);
	});
}
function NET_ServerRAW(_type, _port, _max_clients) : NET_Server(_type, _port, _max_clients) constructor {
	self.network.setRAW(true);
	self.createServer = function() {
		return network_create_server_raw(self.type, self.port, self.maxClients);
	}
}