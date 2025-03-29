function NET_InputManager() constructor {
	self.frameInput = {};
	self.totalPlayers = 2;
	self.lastInput = {};
	self.keys = [];
	static setKeys = function(_keys) {
		self.keys = _keys;	
	}
	static getKeys = function() {
		return self.keys;	
	}
	self.getLocal = function(_index) {
		return {};	
	};
	static fromBinary = function(_binary) {
		var _keys = self.keys;
		var _len = array_length(_keys);
		var _result = {};
		for (var i = 0; i < _len; i++) {
			var _key = _keys[i];
			_result[$ _key] = (_binary & (1 << i)) >> i;
		}
		return _result;
	}
	static toBinary = function(_input) {
		var _keys = self.keys;
		var _len = array_length(_keys);
		var _result = 0;
		for (var i = 0; i < _len; i++) {
			var _key = _keys[i];
			_result += _input[$ _key] << i;
		}
		return _result;
	}
	static getEmptyInput = function() {
		var _keys = self.keys;
		var _len = array_length(_keys);
		var _result = {};
		for (var i = 0; i < _len; i++) {
			var _key = _keys[i];
			_result[$ _key] = false;
		}
		return _result;
	}
	static inputJoin = function(_input1, _input2) {
		var _keys = struct_get_names(_input1);
		var _len = array_length(_keys);
		var _result = {};
		for (var i = 0; i < _len; i++) {
			var _key = _keys[i];
			_result[$ _key] = _input1[$ _key] || _input2[$ _key];
		}
		return _result;
	}
	static setTotalPlayers = function(_total_players) {
		self.totalPlayers = _total_players;
	}
	static getTotalPlayers = function() {
		return self.totalPlayers;
	}
	static canContinue = function(_current_frame) {
		return 
			struct_exists(self.frameInput, _current_frame) &&
			struct_names_count(self.frameInput[$ _current_frame]) == self.totalPlayers;
	}
	static getInput = function(_frame, _player_index) {
		if (!self.hasInput(_frame, _player_index)) {
			return getEmptyInput();
		}
		return self.frameInput[$ _frame][$ _player_index];
	}
	static hasInput = function(_frame, _player_index) {
		return 
			struct_exists(self.frameInput, _frame) &&
			struct_exists(self.frameInput[$ _frame], _player_index);
	}
	static getLastInput = function(_player_index) {
		return self.lastInput[$ _player_index];
	}
	static addInput = function(_frame, _player_index, _input) {
		if (!struct_exists(self.frameInput, _frame)) {
			self.frameInput[$ _frame] = {};
		}
		self.frameInput[$ _frame][$ _player_index] = _input;
		self.lastInput[$ _player_index] = _input;
	}
	static isInputEqual = function(_input1, _input2) {
		var _keys = struct_get_names(_input1);
		var _len = array_length(_keys);
		for (var i = 0; i < _len; i++) {
			var _key = _keys[i];
			if (_input1[$ _key] != _input2[$ _key]) return false;
		}
		return true;
	}
	static removeFrame = function(_frame) {
		struct_remove(self.frameInput, _frame);	
	}
	static deleteFramesUntil = function(_frame) {
		self.checkFrame = _frame;
		var _frames = array_filter(struct_get_names(self.frameInput), function(_frame) {
			return real(_frame) < checkFrame;
		});	
		array_foreach(_frames, function(_frame) {
			self.removeFrame(_frame);
		});
		
	}
}