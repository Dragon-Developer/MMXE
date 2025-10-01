/// @function InputMotion()
/// @description Tracks sequences of directions and button presses to detect configurable motion commands.
function ComponentMotionInput() : ComponentBase() constructor {
    input = undefined;
    facing = 1; // 1 = right, -1 = left

    buffer_size = 120; // How many sequence entries to keep
    sequence = []; // { dir, buttons, frame }
    motions = []; // List of motion descriptors { name, dirs, button, callback }
    frame = 0;

    button_names = [];
    dir_map = { left: "left", right: "right", up: "up", down: "down" };

    expire_frames = 15; // Entries older than this are removed from sequence
    gap_max = 20; // Max frames allowed between compressed steps when matching a pattern

    // CONFIGURATION
    self.set_facing = function(_facing) {
        facing = (_facing >= 0) ? 1 : -1;
        return self;
    }

    self.set_input = function(_input) {
        input = _input;
        return self;
    }

    self.set_buttons = function(_buttons_array) {
        button_names = _buttons_array;
        return self;
    }

    self.set_directions = function(_map) {
        // _map may contain any of { left, right, up, down } keys
        if (!is_undefined(_map.left)) dir_map.left = _map.left;
        if (!is_undefined(_map.right)) dir_map.right = _map.right;
        if (!is_undefined(_map.up)) dir_map.up = _map.up;
        if (!is_undefined(_map.down)) dir_map.down = _map.down;
        return self;
    }

    self.set_buffer_size = function(_size) {
        buffer_size = _size;
        return self;
    }

    self.set_expire_frames = function(_frames) {
        expire_frames = _frames;
        return self;
    }

    self.set_gap_max = function(_frames) {
        gap_max = _frames;
        return self;
    }

    // MOTION MANAGEMENT
    self.add_motion = function(_name, _dirs, _button, _callback) {
        var _m = {
            name: _name,
            dirs: _dirs,
            button: _button,
            callback: _callback
        };
        array_push(motions, _m);
        return self;
    }

    self.reset = function() {
        sequence = [];
        frame = 0;
        return self;
    }

    // MAIN LOOP
    self.step = function() {
        frame++;

        var _dir = self.__get_direction();
        var _buttons = self.__get_buttons();

        if (_dir != 5 || array_length(_buttons) > 0) {
            var _entry = { dir:_dir, buttons:_buttons, frame:frame };
            array_push(sequence, _entry);
            if (array_length(sequence) > buffer_size) {
                array_delete(sequence, 0, 1);
            }
        }

        // Expire old inputs
        var _i = 0;
        while (_i < array_length(sequence)) {
            if (frame - sequence[_i].frame > expire_frames) {
                array_delete(sequence, _i, 1);
            } else {
                _i++;
            }
        }

        // Check motions
        var _mi = 0;
        while (_mi < array_length(motions)) {
            var _m = motions[_mi];
            if (self.__check_motion(_m)) {
                if (!is_undefined(_m.callback)) {
                    _m.callback();
                }
                self.reset();
                break;
            }
            _mi++;
        }
        return self;
    }
	
	self.on_register = function(){
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
		});
	}

    // INPUT CONVERSION (relative numpad)
    self.__get_direction = function() {
        if (is_undefined(input)) return 5;

        var _x = input.get_input(dir_map.right) - input.get_input(dir_map.left);
        var _y = input.get_input(dir_map.down)  - input.get_input(dir_map.up);

        var _fx = (facing > 0) ? 1 : -1;
        var _rx = _x * _fx;

        if (_rx == 0 && _y == 0) return 5;
        if (_rx == 0 && _y < 0)  return 8;
        if (_rx == 0 && _y > 0)  return 2;
        if (_rx > 0 && _y == 0)  return 6;
        if (_rx < 0 && _y == 0)  return 4;
        if (_rx > 0 && _y > 0)   return 3;
        if (_rx < 0 && _y > 0)   return 1;
        if (_rx > 0 && _y < 0)   return 9;
        if (_rx < 0 && _y < 0)   return 7;
        return 5;
    }

    self.__get_buttons = function() {
        var _out = [];
        if (is_undefined(input)) return _out;
        var _i = 0;
        while (_i < array_length(button_names)) {
            var _btn = button_names[_i];
            if (input.get_input_pressed(_btn)) {
                array_push(_out, _btn);
            }
            _i++;
        }
        return _out;
    }

    // MOTION MATCHING
    self.__compress_sequence = function() {
        var _compressed = [];
        var _last_dir = -1;
        var _i = 0;
        while (_i < array_length(sequence)) {
            var _d = sequence[_i].dir;
            var _b = sequence[_i].buttons;
            if (_d != _last_dir || array_length(_b) > 0) {
                array_push(_compressed, sequence[_i]);
                _last_dir = _d;
            }
            _i++;
        }
        return _compressed;
    }

    // Returns struct { index, frame } of the compressed step that matched last element, or -1 if no match
    self.__match_dirs = function(_compressed, _dir_pattern) {
        var _start = 0;
        while (_start <= array_length(_compressed) - 1) {
            var _idx_pattern = 0;
            var _last_frame = -999;
            var _i = _start;
            while (_i < array_length(_compressed)) {
                var _step = _compressed[_i];

                if (_idx_pattern > 0) {
                    if (_step.frame - _last_frame > gap_max) {
                        break;
                    }
                }

                if (_step.dir == _dir_pattern[_idx_pattern]) {
                    _idx_pattern++;
                    _last_frame = _step.frame;
                }

                if (_idx_pattern == array_length(_dir_pattern)) {
                    return { index: _i, frame: _last_frame };
                }

                _i++;
            }
            _start++;
        }
        return -1;
    }

    // Search the original sequence for the required button AFTER the compressed match index
    self.__check_button_after = function(_start_index, _btn_pattern) {
		var _j = _start_index;
		while (_j < array_length(sequence)) {
		    var _f = sequence[_j];
		    if (array_length(_f.buttons) > 0 && array_contains(_f.buttons, _btn_pattern)) {
		        return true;
		    }
		    _j++;
		}
		return false;
    }

    self.__check_motion = function(_m) {
        var _dir_pattern = _m.dirs;
        var _btn_pattern = _m.button;

        var _compressed = self.__compress_sequence();
        var _match = self.__match_dirs(_compressed, _dir_pattern);

        if (is_struct(_match)) {
            return self.__check_button_after(_match.index, _btn_pattern);
        }
        return false;
    }

}
