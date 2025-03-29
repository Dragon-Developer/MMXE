function NET_NetworkSync(_pubsub) constructor {
	self.owner = other;
	self.framesBySocket = {};
	self.pubsub = _pubsub;
	static addPing = function(_socket, _ping) {
		self.addSocket(_socket);
		var _frames = self.framesBySocket[$ _socket];
		_frames.addPing(_ping);
	}
	static processData = function(_params) {
		var _type = _params.type;
		if (!self.pubsub.hasTopic(_type)) return;
		self.pubsub.getTopic(_type).publish(_params.data);
	}
	static addSocket = function(_socket) {
		if (!struct_exists(self.framesBySocket, _socket)) {
			self.framesBySocket[$ _socket] = new NET_NetworkGameFrameCollection();	
			return true;
		}
		return false;
	}
	static addData = function(_params) {
		var _socket = _params.data.id;
		self.addSocket(_socket);
		var _frames = self.framesBySocket[$ _socket];
		_frames.addDataToCurrentFrame(_params);
	}
	static frameAdvance = function(_socket) {
		self.addSocket(_socket);
		var _frames = self.framesBySocket[$ _socket];
		_frames.addFrame();
	}
	static step = function() {
		struct_foreach(self.framesBySocket, function(_socket) {
			var _frames = self.framesBySocket[$ _socket];
			_frames.process();
		});
	}
}
function NET_NetworkGameFrameCollection() constructor {
	self.owner = other;
	self.frames = [];
	self.maxDelay = 10;
	self.pings = [];
	self.maxDelayUpdateRate = 3;
	static addPing = function(_ping) {
		array_push(self.pings, _ping);
		var _length = array_length(self.pings);
		if (_length < self.maxDelayUpdateRate) return;
		var _sum = array_reduce(self.pings, function(_prev, _current) {
			return _prev + _current;
		});
		self.pings = [];
		var _average = _sum / _length;
		var _fps = game_get_speed(gamespeed_fps);
		var _new_delay = ceil((_average / 1000) * _fps);
		self.maxDelay = _new_delay;
	}
	static process = function() {
		var _length = array_length(self.frames);	
		var _deleted = 0;
		var _min_deleted = max(1, _length - self.maxDelay);
		if (_min_deleted > 1) {
			_min_deleted = max(2, _min_deleted / 10);	
		}
		do {
			if (_length == 0) break;
			var _frame = self.frames[0];
			_frame.process();
			array_delete(self.frames, 0, 1);	
			_length -= 1;
			_deleted ++;
		} until (_deleted >= _min_deleted);	
	}
	static processData = function(_data) {
		self.owner.processData(_data);	
	}
	static addFrame = function() {
		array_push(self.frames, new NET_NetworkGameFrame());
	}
	static addDataToCurrentFrame = function(_data) {
		if (array_length(self.frames) == 0) {
			self.addFrame();
		}
		var _current_frame = array_last(self.frames);
		_current_frame.addData(_data);
	}
}
function NET_NetworkGameFrame() constructor {
	self.owner = other; 
	self.dataArray = [];
	static addData = function(_data) {
		array_push(self.dataArray, _data);
	}
	static process = function() {
		var _length = array_length(self.dataArray);
		for (var i = 0; i < _length; i++) {
			self.owner.processData(self.dataArray[i]);
		}
	}
}