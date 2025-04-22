function GameInput() : NET_InputManager() constructor {
	self.setKeys([
		"left",
		"right",
		"up",
		"down",
		"jump",
		"dash",
		"shoot",
	]);
    self.getLocal = function(_index = 0) {
        var _input = {};
        for (var _i = 0, _len = array_length(self.keys); _i < _len; _i++) {
			var _key = self.keys[_i];
            _input[$ _key] = input_check(_key, _index);
        }
        return _input;
    };
}
