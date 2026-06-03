function ComponentPlayerInput() : ComponentInputBase() constructor {
    self.__input = GAME.inputs.getEmptyInput();
    self.__inputPressed = GAME.inputs.getEmptyInput();
    self.__inputPressedBuffer = [];
	self.__BufferLength = 4;
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
	self.RecordedTranslationLetters = {left: "L", right: "R", up: "U", down: "D", dash: "F", shoot: "P", shoot2: "A", shoot3: "G", shoot4: "O", jump: "J", switchLeft: "Y", switchRight: "T", pause: "Z"};
		
	self.using_scripted_inputs = false;
	self.scripted_inputs = [{left: false, right: false, dash: true, shoot: false, shoot2: false, shoot3: false, shoot4: false, jump: true, switchLeft: false, switchRight: false}];
	self.scripted_input_index = 0;
	
	self.write_inputs = false;
	self.last_inputs = "";
	self.input_change_time = -1;
	self.current_recorded_input = "";
	self.input_file = undefined;
	self.saved_inputs = [];
		
	self.init = function(){
		self.buffer_reset();
		
		if(keyboard_check(ord("6")) || global.settings.auto_record_inputs){
			
			if(keyboard_check(vk_shift)){
				if(using_scripted_inputs){
					using_scripted_inputs = false;
					scripted_input_index = 0;
				} else {
					input_file = file_text_open_read(game_save_id + "recorded inputs.json");
					scripted_inputs = [];
				
					var _finished = false
				
					while(!_finished){
						var _input_struct = {left: false, right: false,up: false, down: false, dash: false, shoot: false, shoot2: false, shoot3: false, shoot4: false, jump: false, switchLeft: false, switchRight: false, pause: false}
						var _inputs = file_text_read_string(input_file);
					
						//bail if the input file is done
						if(_inputs == "Maverick dead"){
							_finished = true;
							continue;
						}
					    file_text_readln(input_file);
					
						//convert inputs to struct
						if(__input_string_contains(_inputs, "L"))//left
							_input_struct.left = true;
						if(__input_string_contains(_inputs, "R"))//right
							_input_struct.right = true;
						if(__input_string_contains(_inputs, "U"))//up
							_input_struct.up = true;
						if(__input_string_contains(_inputs, "D"))//down
							_input_struct.down = true;
						if(__input_string_contains(_inputs, "F"))//dash
							_input_struct.dash = true;
						if(__input_string_contains(_inputs, "P"))//shoot 1
							_input_struct.shoot = true;
						if(__input_string_contains(_inputs, "A"))//shoot 2
							_input_struct.shoot2 = true;
						if(__input_string_contains(_inputs, "G"))//shoot 3
							_input_struct.shoot3 = true;
						if(__input_string_contains(_inputs, "O"))//shoot 4
							_input_struct.shoot4 = true;
						if(__input_string_contains(_inputs, "J"))//jump
							_input_struct.jump = true;
						if(__input_string_contains(_inputs, "Z"))//pause
							_input_struct.pause = true;
						if(__input_string_contains(_inputs, "Y"))//switch left
							_input_struct.switchLeft = true;
						if(__input_string_contains(_inputs, "T"))//switch right
							_input_struct.switchRight = true;
					
					    var _repeats = file_text_read_real(input_file);
						_repeats++;
					    file_text_readln(input_file);
					
						for(var w = 0; w < _repeats; w++){
							array_push(scripted_inputs, _input_struct)
						}
					}
				
					file_text_close(input_file);
				
					using_scripted_inputs = true;
					var _x = 8
					var _y = 8
	
					if(instance_exists(obj_camera)){
					_x = instance_nearest(0,0,obj_camera).x + 8
					_y = instance_nearest(0,0,obj_camera).y + 8
					}
	
					if !keyboard_check(vk_shift) {
						var _response = instance_create_depth(_x, _y, -15000, obj_damage_number);
						_response.number = "PLAYING BACK INPUT"
					}
				}
			} else {
				write_inputs = !write_inputs
				var _x = 8
				var _y = 8
	
				if(instance_exists(obj_camera)){
				_x = instance_nearest(0,0,obj_camera).x + 8
				_y = instance_nearest(0,0,obj_camera).y + 8
				}
	
				var _response = instance_create_depth(_x, _y, -15000, obj_damage_number);
				_response.number = write_inputs ? "RECORDING" : "STOPPED RECORDING"
			
				if(write_inputs){
					input_file = file_text_open_write(game_save_id + "recorded inputs.json");
				} else {
				    file_text_write_string(input_file, "Maverick dead");
					file_text_close(input_file);
				}
			}
		}
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
	
	self.get_player_index = function(){
		return self.__player_index;
	}
	
	self.__input_check = function(_verb) {
		if(self.using_scripted_inputs)
			return self.input_check_scripted(_verb);
		else
			return self.input_check_regular(_verb);
	}
	
	self.input_check_scripted = function(_verb){
		var _set = {};
		if(array_length(self.scripted_inputs) <= self.scripted_input_index){
			self.using_scripted_inputs = false;
			self.scripted_input_index = 0;
			return input_check_regular(_verb);
		}
		
		try{
			_set = self.scripted_inputs[self.scripted_input_index];
		} catch(_err){
			log(_err)
			_set = {
				left: false,
				right: false,
				jump: true,
				dash: true,
				shoot: false,
				shoot2: false,
				shoot3: false,
				shoot4: false,
				switchLeft: false,
				switchRight: false,
				pause: false,
				up: false,
				down: false
		    }
		}
		
		
		return _set[$ _verb]
	}
	
	self.input_check_regular = function(_verb){
		if (self.__locked) return __input[$ _verb];
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
		if(is_undefined(self.__input)) return;
		
		if using_scripted_inputs
			self.scripted_input_index++;
		if(write_inputs){
			self.saved_inputs[array_length(saved_inputs)] = "";
		
			current_recorded_input = ""
		}
		
	    array_foreach(self.verbs, function(_verb, _index) {
	        var _isPressed = self.__input_check(_verb);
	        self.__inputPressed[$ _verb] = struct_exists(self.__input, _verb) && !self.__input[$ _verb] && _isPressed;
	        self.__inputReleased[$ _verb] = struct_exists(self.__input, _verb) && self.__input[$ _verb] && !_isPressed;
			self.__input[$ _verb] = _isPressed;
			
			if(write_inputs){
				try{
					if(_isPressed)
						current_recorded_input += string(self.RecordedTranslationLetters[$ _verb]);
				} catch (_err){
					log(string(_verb) + " is not being recognized properly!")
				}
			}
			
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
		
		if(write_inputs){
			//self.saved_inputs[array_length(saved_inputs) - 1] = current_recorded_input;
			if(last_inputs != current_recorded_input){
				
			    file_text_write_string(input_file, last_inputs);
			    file_text_writeln(input_file);
			    file_text_write_string(input_file, input_change_time);
			    file_text_writeln(input_file);
				input_change_time = 0;
				log(last_inputs);
				last_inputs = current_recorded_input;
			} else {
				input_change_time++;
			}
		}
			
		
    };
	
	self.step = function() {
		if (self.timescale != 1) self.timescale = 1
			
		if(keyboard_check_pressed(ord("5"))){
			write_inputs = !write_inputs
			var _x = 8
			var _y = 8
	
			if(instance_exists(obj_camera)){
			_x = instance_nearest(0,0,obj_camera).x + 8
			_y = instance_nearest(0,0,obj_camera).y + 8
			}
	
			var _response = instance_create_depth(_x, _y, -15000, obj_damage_number);
			_response.number = write_inputs ? "RECORDING" : "STOPPED RECORDING"
			
			if(write_inputs){
				input_file = file_text_open_write(game_save_id + "recorded inputs.json");
			} else {
			    file_text_write_string(input_file, "Maverick dead");
				file_text_close(input_file);
			}
		}
		
		if(keyboard_check_pressed(ord("7"))){
			if(using_scripted_inputs){
				using_scripted_inputs = false;
				scripted_input_index = 0;
			} else {
				input_file = file_text_open_read(game_save_id + "recorded inputs.json");
				scripted_inputs = [];
				
				var _finished = false
				
				while(!_finished){
					var _input_struct = {left: false, right: false,up: false, down: false, dash: false, shoot: false, shoot2: false, shoot3: false, shoot4: false, jump: false, switchLeft: false, switchRight: false, pause: false}
					var _inputs = file_text_read_string(input_file);
					
					//bail if the input file is done
					if(_inputs == "Maverick dead"){
						_finished = true;
						continue;
					}
				    file_text_readln(input_file);
					
					//convert inputs to struct
					if(__input_string_contains(_inputs, "L"))//left
						_input_struct.left = true;
					if(__input_string_contains(_inputs, "R"))//right
						_input_struct.right = true;
					if(__input_string_contains(_inputs, "U"))//up
						_input_struct.up = true;
					if(__input_string_contains(_inputs, "D"))//down
						_input_struct.down = true;
					if(__input_string_contains(_inputs, "F"))//dash
						_input_struct.dash = true;
					if(__input_string_contains(_inputs, "P"))//shoot 1
						_input_struct.shoot = true;
					if(__input_string_contains(_inputs, "A"))//shoot 2
						_input_struct.shoot2 = true;
					if(__input_string_contains(_inputs, "G"))//shoot 3
						_input_struct.shoot3 = true;
					if(__input_string_contains(_inputs, "O"))//shoot 4
						_input_struct.shoot4 = true;
					if(__input_string_contains(_inputs, "J"))//jump
						_input_struct.jump = true;
					if(__input_string_contains(_inputs, "Z"))//pause
						_input_struct.pause = true;
					if(__input_string_contains(_inputs, "Y"))//switch left
						_input_struct.switchLeft = true;
					if(__input_string_contains(_inputs, "T"))//switch right
						_input_struct.switchRight = true;
					
				    var _repeats = file_text_read_real(input_file);
					_repeats++;
				    file_text_readln(input_file);
					
					for(var w = 0; w < _repeats; w++){
						array_push(scripted_inputs, _input_struct)
					}
				}
				
				file_text_close(input_file);
				
				using_scripted_inputs = true;
				var _x = 8
				var _y = 8
	
				if(instance_exists(obj_camera)){
				_x = instance_nearest(0,0,obj_camera).x + 8
				_y = instance_nearest(0,0,obj_camera).y + 8
				}
	
				if !keyboard_check(vk_shift) {
					var _response = instance_create_depth(_x, _y, -15000, obj_damage_number);
					_response.number = "PLAYING BACK INPUT"
				}
			}
		}
		
		if(using_scripted_inputs){
		}
		
		self.update_inputs();
		//log(string(__locked ? "Locked" : "Free") + " " + string(__locked))
	}

	self.make_scripted_inputs_from_compressed = function(_inputs){
		self.scripted_inputs = [];
		var _finished = false
		var _index = -1;
				
		while(!_finished){
			var _input_struct = {left: false, right: false,up: false, down: false, dash: false, shoot: false, shoot2: false, shoot3: false, shoot4: false, jump: false, switchLeft: false, switchRight: false, pause: false}
				
			
			_index++
			//bail if the input file is done
			if(!is_array(_inputs))
				log(_inputs)
			
			if(_inputs[_index] == "Maverick dead"){
				_finished = true;
				continue;
			}
			
			var _string = _inputs[_index]
					
			//convert inputs to struct
			if(__input_string_contains(_string, "L"))//left
				_input_struct.left = true;
			if(__input_string_contains(_string, "R"))//right
				_input_struct.right = true;
			if(__input_string_contains(_string, "U"))//up
				_input_struct.up = true;
			if(__input_string_contains(_string, "D"))//down
				_input_struct.down = true;
			if(__input_string_contains(_string, "F"))//dash
				_input_struct.dash = true;
			if(__input_string_contains(_string, "P"))//shoot 1
				_input_struct.shoot = true;
			if(__input_string_contains(_string, "A"))//shoot 2
				_input_struct.shoot2 = true;
			if(__input_string_contains(_string, "G"))//shoot 3
				_input_struct.shoot3 = true;
			if(__input_string_contains(_string, "O"))//shoot 4
				_input_struct.shoot4 = true;
			if(__input_string_contains(_string, "J"))//jump
				_input_struct.jump = true;
			if(__input_string_contains(_string, "Z"))//pause
				_input_struct.pause = true;
			if(__input_string_contains(_string, "Y"))//switch left
				_input_struct.switchLeft = true;
			if(__input_string_contains(_string, "T"))//switch right
				_input_struct.switchRight = true;
					
			_index++;
			var _repeats = _inputs[_index]
			_repeats++;
					
			for(var w = 0; w < _repeats; w++){
				array_push(scripted_inputs, _input_struct)
			}
		}
		
		scripted_input_index = 1;
		using_scripted_inputs = true;
	}

	self.draw = function(){
		if(!global.debug) 
			return;
		
		if(write_inputs){
			var _str = current_recorded_input;
			
			draw_string_condensed(_str, get_instance().x - 24, get_instance().y + 32)
			draw_string(array_length(saved_inputs), get_instance().x, get_instance().y + 22)
		}
			
		if(using_scripted_inputs){
			//var _inputs = string(scripted_inputs[scripted_input_index]);
			var keys = variable_struct_get_names(__input);
			var _str = ""
			
			//LAG MOTHERFUCKER LAG!
			try{
				for(var p = 0; p < 13; p++){
					var e = keys[p];
					if(__input[$ e] == true)
						_str += string(RecordedTranslationLetters[$ e])
				}
			} catch(_err){
				log("The recorded input system messed up!")
			}
			
			draw_string_condensed(_str, get_instance().x - 24, get_instance().y + 32)
			draw_string(scripted_input_index, get_instance().x, get_instance().y + 22)
		}
	}
	
    self.get_input = function(_verb) {
        if (struct_exists(self.__input, _verb)) return self.__input[$ _verb];
		return false;
    };

    self.get_input_pressed = function(_verb) {
		if(is_undefined(self.__input)) return;
		//gonna make a system to 'extend' the press period. its effectively input buffering
		var _result = false;
        if (struct_exists(self.__inputPressed, _verb)) _result = self.__inputPressed[$ _verb];
		for(var e = 0; e < array_length(self.__inputPressedBuffer); e++){
			if(self.__inputPressedBuffer[e][$ _verb] && self.__useBuffer) _result = true;
		}
		return _result;
    };
	
	self.get_input_pressed_raw = function(_verb) {
		if(is_undefined(self.__input)) return;
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
