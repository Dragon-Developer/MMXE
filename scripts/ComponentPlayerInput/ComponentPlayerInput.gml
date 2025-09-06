function ComponentPlayerInput() : ComponentInputBase() constructor {
    self.__input = GAME.inputs.getEmptyInput();
    self.__inputPressed = GAME.inputs.getEmptyInput();
    self.__inputPressedBuffer = [];
	self.__BufferLength = 3;
	self.__useBuffer = true;
    self.__inputReleased = GAME.inputs.getEmptyInput();
	self.__swap_horizontal = false;
	self.__player_index = 0;
	self.__locked = false;
    self.verbs = GAME.inputs.getKeys();
	self.serializer = new NET_Serializer();
	self.serializer
		.addClone("__input")
		.addClone("__inputPressed")
		.addClone("__inputReleased")
		.addClone("__swap_horizontal")
		.addClone("__player_index")
		
	self.__inputBufferActive = {left: false, right: false, dash: true, shoot: false, shoot2: false, shoot3: false, shoot4: false, jump: true, switchLeft: false, switchRight: false};
		
	self.using_scripted_inputs = false;
	self.scripted_inputs = [{left: false, right: false, dash: true, shoot: false, shoot2: false, shoot3: false, shoot4: false, jump: true, switchLeft: false, switchRight: false}];
	self.scripted_input_index = 0;
	
	self.write_inputs = global.settings.write_inputs;
		
	self.init = function(){
		self.buffer_reset();
	}
	self.buffer_reset = function(){
		self.__inputPressedBuffer = [];
		for(var p = 0; p < __BufferLength; p++){
			array_push(self.__inputPressedBuffer, GAME.inputs.getEmptyInput());
		}
	}
		
	self.set_swap_horizontal = function(_value) {
		self.__swap_horizontal = _value;	
	}
	self.set_player_index = function(_index) {
		self.__player_index = _index;	
	}
	self.__input_check = function(_verb) {
		if(self.using_scripted_inputs)
			return self.input_check_scripted(_verb);
		else
			return self.input_check_regular(_verb);
	}
	
	self.input_check_scripted = function(_verb){
		self.scripted_input_index++;
		return self.scripted_inputs[self.scripted_input_index - 1][$ _verb];
	}
	
	self.input_check_regular = function(_verb){
		if (self.__locked) return false;
		if (self.__swap_horizontal) {
			if (_verb == "right") {
				_verb = "left";
			} else if (_verb == "left") {
				_verb = "right";	
			}
		}
		var _input = GAME.get_input(self.__player_index);
		if (struct_exists(_input, _verb))
			return _input[$ _verb];
		return false;
	}

    self.update_inputs = function() {
	    array_foreach(self.verbs, function(_verb) {
	        var _isPressed = self.__input_check(_verb);
	        self.__inputPressed[$ _verb] = struct_exists(self.__input, _verb) && !self.__input[$ _verb] && _isPressed;
	        self.__inputReleased[$ _verb] = struct_exists(self.__input, _verb) && self.__input[$ _verb] && !_isPressed;
			self.__input[$ _verb] = _isPressed;
			
			if(self.__inputBufferActive[$ _verb]){
				//forgive me father for i have sinned
				for(var e = array_length(self.__inputPressedBuffer) - 1; e >= 0; e--){
					if(e == 0){
						self.__inputPressedBuffer[e][$ _verb] = self.__inputPressed[$ _verb];
					} else {
						self.__inputPressedBuffer[e][$ _verb] = self.__inputPressedBuffer[e - 1][$ _verb];
					}
				}
			}
	    });
    };
	
	self.step = function() {
		self.update_inputs();
		//log(string(__locked ? "Locked" : "Free") + " " + string(__locked))
	}

    self.get_input = function(_verb) {
        if (struct_exists(self.__input, _verb)) return self.__input[$ _verb];
		return false;
    };

    self.get_input_pressed = function(_verb) {
		//gonna make a system to 'extend' the press period. its effectively input buffering
		var _result = false;
        if (struct_exists(self.__inputPressed, _verb)) _result = self.__inputPressed[$ _verb];
		for(var e = 0; e < array_length(self.__inputPressedBuffer); e++){
			if(self.__inputPressedBuffer[e][$ _verb] && self.__useBuffer) _result = true;
		}
		return _result;
    };
	
	self.get_input_pressed_raw = function(_verb) {
		//gonna make a system to 'extend' the press period. its effectively input buffering
		var _result = false;
        if (struct_exists(self.__inputPressed, _verb)) _result = self.__inputPressed[$ _verb];
		return _result;
    };
	
	self.get_input_released = function(_verb) {
        if (struct_exists(self.__inputReleased, _verb)) return self.__inputReleased[$ _verb];
		return false;
    };
	
	self.get_input_bind = function(_verb){
		log(self.input[$ _verb])
		return self.input[$ _verb];
	}
}
