function NET_NetworkWindow() constructor {
	self.owner = other;
	self.sockets = {};	
	self.checkSocket = function(_socket) {
		if (!struct_exists(self.sockets, _socket)) {
			self.sockets[$ _socket] = {
				socket: _socket,
				pos: 0,
				buffers: {}
			};
		}
	}
	self.getPos = function(_socket) {
		self.checkSocket(_socket);
		return self.sockets[$ _socket].pos;
	}
	self.setPos = function(_socket, _pos) {
		self.checkSocket(_socket);
		var _pos_current = max(_pos, self.sockets[$ _socket].pos);
		self.pos = _pos_current;
		self.socket = _socket;
		var _buffers = self.sockets[$ _socket].buffers;
		var _positions = array_filter(struct_get_names(_buffers), function(_pos) { return real(_pos) < self.pos });
		array_foreach(_positions, function(_pos) {
			buffer_delete(self.sockets[$ socket].buffers[$ _pos]);
			struct_remove(self.sockets[$ socket].buffers, _pos);
		});
	}
	self.addBuffer = function(_socket, _buffer) {
		self.checkSocket(_socket);
		var _pos = self.sockets[$ _socket].pos++;
		self.sockets[$ _socket].buffers[$ _pos] = _buffer;
	}
	self.insertBuffer = function(_socket, _buffer, _pos) {
		self.checkSocket(_socket);
		var _next_pos = self.sockets[$ _socket].pos;
		if (_pos < _next_pos) return;
		if (struct_exists(self.sockets[$ _socket].buffers, _pos)) return;
		self.sockets[$ _socket].buffers[$ _pos] = _buffer;
	}
	self.step = function(_socket) {
		self.checkSocket(_socket);
		var _window = self.sockets[$ _socket];
		var _buffers = _window.buffers;
		while (struct_exists(_buffers, _window.pos)) {
			owner.onMessage(_buffers[$ _window.pos], _window.socket);
			buffer_delete(_buffers[$ _window.pos]);
			struct_remove(_buffers, _window.pos);
			_window.pos++;
		}
	}
}