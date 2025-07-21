function GameInput() : NET_InputManager() constructor {
	self.setKeys([
		"left",
		"right",
		"up",
		"down",
		"jump",
		"dash",
		"shoot",
		"shoot2",
		"shoot3",
		"shoot4",
		"switchLeft",
		"switchRight"
	]);
    self.getLocal = function(_index = 0) {
		log(_index)
        var _input = {};
        for (var _i = 0, _len = array_length(self.keys); _i < _len; _i++) {
			var _key = self.keys[_i];
            _input[$ _key] = input_check(_key, _index);
        }
        return _input;
    };
}
