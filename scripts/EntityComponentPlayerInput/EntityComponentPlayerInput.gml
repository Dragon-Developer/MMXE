function EntityComponentPlayerInput() : EntityComponentInputBase() constructor {
    self.__input = {};
    self.__inputPressed = {};
	self.__swap_horizontal = false;
	self.__player_index = 0;
    self.verbs = GAME.inputs.getKeys();
	self.set_swap_horizontal = function(_value) {
		self.__swap_horizontal = _value;	
	}
	self.set_player_index = function(_index) {
		self.__player_index = _index;	
	}
	self.__input_check = function(_verb) {
		if (self.__swap_horizontal) {
			if (_verb == "right") {
				_verb = "left";
			} else if (_verb == "left") {
				_verb = "right";	
			}
		}
		var _input = global.game.get_input(self.__player_index);
		if (struct_exists(_input, _verb))
			return _input[$ _verb];
		return false;
	}

    self.update_inputs = function() {
        array_foreach(self.verbs, function(_verb) {
            var _isPressed = self.__input_check(_verb);
            self.__inputPressed[$ _verb] = struct_exists(self.__input, _verb) && !self.__input[$ _verb] && _isPressed;
            self.__input[$ _verb] = _isPressed;
        });
    };
	
	self.step = function() {
		self.update_inputs();	
	}

    self.get_input = function(_verb) {
        if (struct_exists(self.__input, _verb)) return self.__input[$ _verb];
		return false;
    };

    self.get_input_pressed = function(_verb) {
        if (struct_exists(self.__inputPressed, _verb)) return self.__inputPressed[$ _verb];
		return false;
    };
	
	self.draw = function() {
		//draw_text(parent.get_instance().x, parent.get_instance().y - 80, "player");
	}
	
}
