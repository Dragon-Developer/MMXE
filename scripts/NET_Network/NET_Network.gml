/// @function					NET_Network()
function NET_Network() constructor {
	self.owner = other;
	self.buffer = undefined;
	self.raw = false;
	self.type = network_socket_tcp;
	self.defaultSocket = -1;
	self.defaultUDP = {};
	self.compress = false;
	self.reliable = false;
	self.senderWindow = new NET_NetworkWindow();
	self.receiverWindow = new NET_NetworkWindow();
	self.retransmissionRateInterval = 1;
	self.retransmissionTimer = 0;
	self.retransmissionMax = 100;
	self.retransmissionCount = 0;
	self.retransmissionFrequency = 1;
	static step = function() {
		self.retransmissionTimer++;
		if (self.retransmissionTimer < self.retransmissionRateInterval) return;
		self.retransmissionTimer = 0;
		struct_foreach(self.senderWindow.sockets, function(_key, _value) {
			var _socket = _value.socket;
			other.retransmissionCount = 0;
			struct_foreach(_value.buffers, method({ this: other, socket: _socket}, function(_key, _value) {
				this.retransmissionCount++;
				if (this.retransmissionCount >= this.retransmissionMax) return;
				this.sendBuffer(socket, _value, false);				
			}));
		});
	}
	static setRAW = function(_raw) {
		self.raw = _raw;
		return self;
	}
	static setType = function(_type) {
		self.type = _type;	
		return self;
	}
	static setDefaultSocket = function(_socket) {
		self.defaultSocket = _socket;
		return self;
	}
	static setDefaultUDP = function(_ip, _port) {
		self.defaultUDP = new NET_ConnectedUdpSocket(_ip, _port);
		return self;
	}
	static setCompress = function(_value) {
		self.compress = _value;	
		return self;
	}
	static setReliable = function(_reliable) {
		self.reliable = _reliable;
		return self;
	}
	static decompressBuffer = function(_buffer) {
		var _decompressed = buffer_decompress(_buffer);	
		return _decompressed;
	}
	static processBuffer = function(_buffer, _socket) {
		var _buffer_decompressed = _buffer;
		var _id;
		if (reliable) {
			buffer_seek(_buffer, buffer_seek_start, 0);
			var _last_pos = buffer_read(_buffer, buffer_u32);
			_id = buffer_read(_buffer, buffer_u32);
			self.senderWindow.setPos(_socket, _last_pos);
			var _aux_buffer = buffer_create(buffer_get_size(_buffer) - 8, buffer_fixed, 1);
			buffer_copy(_buffer, 8, buffer_get_size(_buffer) - 8, _aux_buffer, 0);
			_buffer = _aux_buffer;
			_buffer_decompressed = _buffer;
		}
		if (compress) {
			_buffer_decompressed = buffer_decompress(_buffer);	
		}	
		if (!reliable) {
			buffer_seek(_buffer_decompressed, buffer_seek_start, 0);
			onMessage(_buffer_decompressed, _socket); 
			buffer_seek(_buffer_decompressed, buffer_seek_end, 0);
			buffer_delete(_buffer_decompressed);	
		} else {
			if (compress) buffer_delete(_buffer);
			receiverWindow.insertBuffer(_socket, _buffer_decompressed, _id);
			receiverWindow.step(_socket);
		}
		if (compress && !reliable) {
			buffer_delete(_buffer_decompressed);	
		}
	}
	static onMessage = function(_buffer, _socket) {};
	/// @function						readBufferText()
	/// @description					Read the buffer as a text.
	/// @param {Id.Buffer} buffer		The index of the buffer to read from.
	/// @returns {String}
	static readBufferText = function(_buffer) {
		if (!compress) {
			return buffer_read(_buffer, buffer_text);
		}
		var _decompressed = buffer_decompress(_buffer);	
		buffer_seek(_decompressed, buffer_seek_start, 0);
		var _text = buffer_read(_decompressed, buffer_text);
		buffer_delete(_decompressed);
		return _text;
	}
	/// @function						sendData()
	/// @description					Send data to socket.
	/// @param {Struct} data			Data to be sent.
	/// @param {Id.Socket} [sockets]	Sockets to send to.
	static sendData = function(_data, _sockets) {
		if (is_undefined(_sockets)) {
			if (type == network_socket_udp) {
				_sockets = self.defaultUDP;	
			} else {
				_sockets = self.defaultSocket;
			}
		}
		if (!is_array(_sockets)) {
			_sockets = [_sockets];	
		}
		var _json_string = json_stringify(_data);
		buffer = buffer_create(1, buffer_grow, 1);
		buffer_seek(buffer, buffer_seek_start, 0);
		buffer_write(buffer, buffer_text, _json_string);
		if (compress) {
			var _compressed = buffer_compress(buffer, 0, buffer_tell(buffer));
			buffer_delete(buffer);
			buffer = _compressed;
			buffer_seek(buffer, 0, buffer_get_size(_compressed));
		}
		array_foreach(_sockets, function(_socket) {
			sendBuffer(_socket, buffer);
		});
		buffer_delete(buffer);
	}
	static sendUDPBuffer = function(_socket, _buffer, _add_to_window = true) {
		var _size = buffer_get_size(_buffer);
		if (reliable) {
			if (_add_to_window) {
				// Add buffer ID to save on senderWindow
				var _copy = buffer_create(buffer_get_size(_buffer) + 4, buffer_fixed, 1);
				var _message_id = self.senderWindow.getPos(_socket);
				buffer_write(_copy, buffer_u32, _message_id);
				buffer_copy(_buffer, 0, buffer_get_size(_buffer), _copy, 4);
				self.senderWindow.addBuffer(_socket, _copy);
				_buffer = _copy;
			}
			_size = buffer_get_size(_buffer) + 4;
			// Add the buffer ID we are waiting to receive
			var _new_buffer = buffer_create(_size, buffer_fixed, 1);
			var _receiver_pos = self.receiverWindow.getPos(_socket);
			buffer_write(_new_buffer, buffer_u32, _receiver_pos);
			buffer_copy(_buffer, 0, buffer_get_size(_buffer), _new_buffer, 4);
			_buffer = _new_buffer;
		}
		var _amount = (self.reliable) ? self.retransmissionFrequency : 1;
		repeat(_amount) {
			if (self.raw) {
				network_send_udp_raw(self.defaultSocket, _socket.ip, _socket.port, _buffer, _size);
			} else {
				network_send_udp(self.defaultSocket, _socket.ip, _socket.port, _buffer, _size);
			}
		}
		if (reliable) {
			buffer_delete(_buffer);	
		}
	}

	static sendTCPBuffer = function(_socket, _buffer) {
		if (raw) {
			network_send_raw(_socket, _buffer, buffer_tell(_buffer));
			return;
		} 
		network_send_packet(_socket, _buffer, buffer_tell(_buffer));
	}
	static sendBuffer = function(_socket, _buffer, _add_to_window = true) {
		if (type == network_socket_udp) {
			self.sendUDPBuffer(_socket, _buffer, _add_to_window);
			return;
		}
		self.sendTCPBuffer(_socket, _buffer);
	}
}
