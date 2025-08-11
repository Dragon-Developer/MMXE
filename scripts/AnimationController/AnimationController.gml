#macro ANIMATION_SPRITE_PREFIX "spr"
//why do we need to have a macro for the animation sprite seperator? it just adds characters
#macro ANIMATION_SPRITE_SEPARATOR "_"

/// @param {string} character	Character name used in animation
function AnimationController(_character = "") constructor {
    enum ANIMATION_MODE {
		SPEED,
		KEYFRAMES
	};
	
	// Private fields
	self.__owner = other;
    self.__collection = {};
    self.__sprite = -1;
    self.__index = 0; 
	self.__frame = 0;
    self.__xscale = 1;
    self.__yscale = 1;
    self.__angle = 0;
    self.__color = c_white;
    self.__alpha = 1;
    self.__character = _character;
    self.__types = {//probably didnt need to hardcode this, but we need better doccumentation anyways. 
        "normal": [""]
    };
    self.__actions = [];
	self.__animations = [];
    self.__animation = "";
    self.__type = "normal";
    self.__props = {};
	self.__events = {};
	self.__event_listeners = {};
	self.__visible = true;
	self.__speed = 1;
	self.__current_animation = {
		mode: ANIMATION_MODE.SPEED,
		speed: 1,
		max_key: undefined
	}
	self.__collage = undefined;
	self.__last_keyframe = -1;
	self.__last_index = -1;
	self.__wait_frames = 0;
	
	self.serializer = new NET_Serializer();
	self.serializer
		.addVariable("__animation")
		.addVariable("__sprite")
		.addVariable("__index")
		.addVariable("__frame")
		.addVariable("__xscale")
		.addVariable("__yscale")
		.addVariable("__angle")
		.addVariable("__color")
		.addVariable("__alpha")
		.addVariable("__character")
		.addVariable("__types")
		.addVariable("__type")
		.addVariable("__visible")
		.addVariable("__speed")
		.addClone("__current_animation")
		.addVariable("__last_keyframe")
		.addVariable("__last_index")
		.addVariable("__wait_frames")
	
	static use_collage = function(_collage) {
		self.__collage = _collage;
		return self;
	}
	/// @param {string} character
	/// @returns {AnimationController} self
	static set_character = function(_character) {
		self.__character = _character;
		return self;
	}
	/// @returns {string}
	static get_character = function() {
		return self.__character;
	}
	/// @param {real} xscale
	/// @returns {AnimationController} self
	static set_xscale = function(_xscale) {
		self.__xscale = _xscale;
		return self;
	}
	/// @returns {real}	
	static get_xscale = function() {
		return self.__xscale;
	}
	/// @param {real} yscale
	/// @returns {AnimationController} self
	static set_yscale = function(_yscale) {
		self.__yscale = _yscale;
		return self;
	}
	/// @param {real} angle
	/// @returns {AnimationController} self
	static set_angle = function(_angle) {
		self.__angle = _angle;
		return self;
	}
	/// @returns {real}
	static get_yscale = function() {
		return self.__yscale;
	}
	/// @param {real} index
	static set_index = function(_index) {
		self.__index = _index;
		return self;
	}
	/// @returns {real}
	static get_index = function() {
		return self.__index;
	}
	/// @param {real} visible
	static set_visible = function(_visible) {
		self.__visible = _visible;
		return self;
	}
	/// @returns {real}
	static get_visible = function() {
		return self.__visible;
	}
	/// @param {real} alpha
	static set_alpha = function(_alpha) {
		self.__alpha = _alpha;
		return self;
	}
	/// @returns {real}
	static get_alpha = function() {
		return self.__alpha;
	}
	/// @returns {Array<string>}
	static get_actions = function() {
		return variable_clone(self.__actions);
	}
	/// @returns {Array<string>}
	static get_animations = function() {
		return variable_clone(self.__animations);
	}
	/// @returns {Array<struct>}
	static get_props = function(_animation = self.__animation) {
		return self.__props[$ _animation];
	}
	/// @param {string} animation
	/// @param {real} key
	/// @param {real} frame
	static add_keyframe = function(_animation, _key, _frame) {
		var _props = get_props(_animation);
		var _keyframes = _props.keyframes;
		var _index = array_find_index(_keyframes, method({ key: _key}, function(_keyframe) { return _keyframe.key == key }));
		if (_index != -1)
			array_delete(_keyframes, _index, 1);
		array_push(_keyframes, { key: _key, frame: _frame });
		self.__refresh_props(_animation);
		if (self.is_playing(_animation)) self.play(_animation, false);
	}
	/// @param {string} animation
	/// @param {real} index
	static remove_keyframe = function(_animation, _index) {
		var _props = get_props(_animation);
		var _keyframes = _props.keyframes;
		array_delete(_keyframes, _index, 1);
		self.__refresh_props(_animation);
		if (self.is_playing(_animation)) self.play(_animation, false);
	}
	static __refresh_props = function(_animation) {
		var _props = get_props(_animation);
		if (struct_exists(_props, "keyframes")) {
			var _max_key = 0;
			var _keyframes = _props[$ "keyframes"];
			var _keyframes = _props.keyframes;
			array_sort(_keyframes, function(_a, _b) { return _a.key - _b.key });
			var _len = array_length(_keyframes);
		    for (var _i = 0; _i < _len; _i++) {
		        _max_key = max(_max_key, _keyframes[_i].key);
		    }
			_props[$ "max_key"] = _max_key;
		}
		
	}
	/// @param {string} animation
    /// @param {struct} props
	/// @returns {AnimationController} self
	static add_animation = function(_animation, _props = {}) {
		_props[$ "action"] ??= _animation;
        array_push(self.__actions, _props[$ "action"]);
        array_push(self.__animations, _animation);
        self.__props[$ _animation] = _props;
		if (struct_exists(_props, "keyframes")) {
			var _max_key = 0;
			var _keyframes = _props[$ "keyframes"];
			var _len = array_length(_keyframes);
		    for (var _i = 0; _i < _len; _i++) {
		        _max_key = max(_max_key, _keyframes[_i].key);
		    }
			_props[$ "max_key"] ??= _max_key;
		}
        return self;
    }
	/// @param {string} type
	/// @param {string} fallback_type
	/// @returns {AnimationController} self
	static add_type = function(_type, _fallback_types = []) {
		if (_type == "") return;
		self.__types[$ _type] = [_type];
		if (!is_array(_fallback_types)) {
			_fallback_types = [_fallback_types];
		}
		self.__types[$ _type] = array_concat([_type], _fallback_types);
        return self;
    }
    /// @param {Array<Array<string>>} arrays
	/// @returns {AnimationController} self
	static add_type_combinations = function(_arrays) {
		var _combinations = CombinationGenerator.generate_with_fallback(_arrays, ANIMATION_SPRITE_SEPARATOR);
		array_foreach(_combinations, function(_combination) {
			self.add_type(_combination.type, _combination.fallbacks);
		});
		return self;
	}
	/// @param {string} event
    /// @param {function} method
	/// @returns {AnimationController} self
	static set_event = function(_event, _method) {
		self.__events[$ _event] = _method;
		return self;
	}
	/// @returns {AnimationController} self
    static init = function() {
        self.__collection = {};
        struct_foreach(self.__types, function(_type, _suffixes) {
	        var _current_animation = {
				sprites: {}
	        };
			self.__collection[$ _type] = _current_animation;
			var _self = self;
	        array_foreach(self.__actions, method({ this: _self, currentAnimation: _current_animation, suffixes: _suffixes }, function(_action) {
				var _len = array_length(suffixes);
				for (var _i = 0; _i < _len; _i++) {
					var _suffix = suffixes[_i];
					if (!is_undefined(currentAnimation[$ "sprites"][$ _action])) {
						return;
					}
					var _array = [];
		            if (ANIMATION_SPRITE_PREFIX != "") {
		                array_push(_array, ANIMATION_SPRITE_PREFIX);
		            }
		            array_push(_array, this.get_character(), _action);
		            if (_suffix != "") {
		                array_push(_array, _suffix);
					}
					// [character, action, suffix]
					var _sprite_name = string_join_ext(ANIMATION_SPRITE_SEPARATOR, _array);
					// if dark asks, i made this function something generic so other systems could use it
					// it does what it used to do, but i moved it to spriteloader so spriteloader 
					// could also load sprite assets
					var _sprite = SpriteLoader.load_sprite(this.__collage, _sprite_name);
					
					if (!is_undefined(_sprite)) {
						currentAnimation[$ "sprites"][$ _action] = _sprite;
					} //else {
						//if(!__input_string_contains(_sprite_name, "x"))
							//log("something fucked up during sprite loading. |" + _sprite_name + "| was unable to be found")
					//}
				}
	        }));
        });
		return self;
    }
	/// @param {real} current_index
	/// @param {real} speed
	/// @param {real} loop_begin
	/// @param {Array<Struct>} keyframes
	/// @param {real} max_key
	function __process_keyframes(_current_index, _speed, _loop_begin, _keyframes, _max_key) {
	    var _key_progress = _current_index + _speed;
		if (self.__wait_frames > 0) {
			self.__wait_frames--;
			_key_progress = _current_index;
		}
	    var _chosen_frame = 0;
		var _len = array_length(_keyframes);
	    if (_key_progress > _max_key) {
	        _key_progress = _loop_begin + (_key_progress - _max_key);
	    }
		if (_key_progress >= _max_key) {
			_key_progress = _max_key;
		}
		for (var _i = 0; _i < _len; _i++) {
	        if (_keyframes[_i].key <= _key_progress) {
	            _chosen_frame = _keyframes[_i].frame;
	        } else {
	            break;
	        }
	    }
	    return { chosen_frame: _chosen_frame, new_index: _key_progress};
	}
	/// @returns {AnimationController} self
    static advance_frame = function() {
		if (self.__animation == "") return;
		if (self.__current_animation == "" || self.__current_animation == undefined) return;
	    var _loop_begin = 0;
	    if (struct_exists(self.__props, self.__animation)) {
	        var _props = self.__props[$ self.__animation];
	        if (struct_exists(_props, "loop_begin")) {
	            _loop_begin = _props.loop_begin;
	        }
	    }
    
	    var _props = self.__props[$ self.__animation];
		
		if(!variable_struct_exists(__current_animation,"mode")){
			variable_struct_set(__current_animation,"mode", ANIMATION_MODE.KEYFRAMES)
		}
		
		// Key-frames mode
	    if (self.__current_animation.mode == ANIMATION_MODE.KEYFRAMES) {
			var _max_key = _props[$ "max_key"];
	        var _result = self.__process_keyframes(self.__index, self.__speed, _loop_begin, _props.keyframes, _max_key);
	        self.__index = _result.new_index;
	        self.__frame = _result.chosen_frame;
	    } 
		// Speed-based mode
		else {
			if (is_undefined(self.__sprite)) return self;
			var _number = 0;
			if (CollageIsImage(self.__sprite)) {
				_number = self.__sprite.GetCount();
			} else {
				_number = sprite_get_number(self.__sprite);
			}
			var _next = self.get_next_frame();
			if (self.__wait_frames > 0) {
				self.__wait_frames--;
				_next = self.__index;
			}
	        self.__index = _next;
	        if (self.__index >= _number) {
	            self.__index = clamp(self.__index - _number + _loop_begin, _loop_begin, _number - 1);
	        }
			self.__frame = floor(self.__index);
	    }
		
		self.__check_for_keyframe_events(self.__index);
		self.__check_for_index_events(self.__frame);
		
	    return self;
	}
	/**
	 * Checks for keyframe events based on the current frame.
	 * @param {real} _frame - The current frame of the animation.
	 */
	static __check_for_keyframe_events = function(_frame) {
	    if (_frame == self.__last_keyframe) return;

	    var _props = self.get_props();
		if(_props == undefined) return;
	    if (struct_exists(_props, "key_events")) {
	        var _key_events = _props.key_events;

	        // Loop through the keyframe events to find those with a "key"
	        for (var _i = 0, _len = array_length(_key_events); _i < _len; _i++) {
	            var _event = _key_events[_i];
				var _args = _event[$ "args"];

	            // Trigger the event associated with this keyframe
	            if (_event.key == _frame) {
	                self.trigger_event(_event.trigger, _args);
	            }
	        }
	    }

	    // Update the last keyframe processed
	    self.__last_keyframe = _frame;
	}

	/**
	 * Checks for sprite index events based on the current index.
	 * @param {real} index - The current index of the sprite.
	 */
	static __check_for_index_events = function(_index) {
	    if (_index == self.__last_index) return;

	    var _props = self.get_props();
		
		if(_props == undefined) return;
		
	    if (struct_exists(_props, "index_events")) {
	        var _index_events = _props.index_events;

	        // Loop through the index events to find those with an "index"
	        for (var _i = 0, _len = array_length(_index_events); _i < _len; _i++) {
	            var _index_event = _index_events[_i];
				var _args = _index_event[$ "args"];
	            // Trigger the event associated with this sprite index
	            if (_index_event.index == _index) {
	                self.trigger_event(_index_event.trigger, _args);
	            }
	        }
	    }

	    // Update the last index processed
	    self.__last_index = _index;
	}
	/**
	 * Adds a listener for a specific event.
	 * If the listener is already added for the event, it will not be added again.
	 * @param {string} _event - The name of the event to listen for.
	 * @param {function} _listener - The function to be called when the event is triggered.
	 */
	static add_event_listener = function(_event, _listener) {
	    // Initialize event listeners if not already initialized
	    self.__event_listeners[$ _event] ??= [];
    
	    // Check if listener is already added
	    if (array_get_index(self.__event_listeners[$ _event], _listener) != -1) return;
    
	    // Add the listener for the event
	    array_push(self.__event_listeners[$ _event], _listener);
		return self;
	}
	/**
	 * Triggers a specific event and calls all registered listeners for that event.
	 * @param {string} event - The name of the event to trigger.
	 */
	static trigger_event = function(_event, _args = undefined) {
	    // Check if there are listeners for the event
	    if (!struct_exists(self.__event_listeners, _event)) return;
    
	    // Loop through the listeners and invoke each one
	    for (var _i = 0, _len = array_length(self.__event_listeners[$ _event]); _i < _len; _i++) {
	        var _listener = self.__event_listeners[$ _event][_i];
	        _listener (_args);
	    }
		return self;
	}
	/// @returns {real}
	static get_next_frame = function() {
	    if (is_undefined(self.__sprite)) return 0;
    
	    var _props = self.get_props();
		var _speed = self.__speed;
		
		if (is_struct(_props)) {
			if (self.__current_animation.mode == ANIMATION_MODE.KEYFRAMES) {
		        var _loop_begin = self.__current_animation.loop_begin;
				var _max_key = self.__current_animation.max_key;
				var _result = self.__process_keyframes(self.__index, self.__speed, _loop_begin, _props.keyframes, _max_key);
		        return _result.chosen_frame;
			}
			if (struct_exists(_props, "speed")) {
				_speed *= self.__current_animation.speed;
			}
	    }
    
		if (!CollageIsImage(self.__sprite) && sprite_exists(self.__sprite)) {
			var _number = sprite_get_number(self.__sprite);
			_speed *= sprite_get_speed(self.__sprite)
			if (sprite_get_speed_type(self.__sprite) == spritespeed_framespersecond) {
				_speed /= game_get_speed(gamespeed_fps);
			}
	    }
	    return self.__index + _speed;
	}
	/// @param {real} speed
	/// @returns {AnimationController} self
	static set_speed = function(_speed) {
		self.__speed = _speed;
		return self;	
	}
	/// @returns {AnimationController} self
    static step = function() {
        self.__sprite = self.get_sprite();
        self.advance_frame();
		return self;
    }
	/// @returns {Asset.Sprite}
	static get_sprite = function(_animation, _type) {
		if (is_undefined(_animation)) _animation = self.__animation;
		if (!struct_exists(self.__props, _animation)) return - 1;
		var _action = self.__props[$ _animation].action;
		return self.get_sprite_from_action(_action, _type);
	}
	/// @returns {Asset.Sprite}
	static get_sprite_from_action = function(_action, _type) {
		if (is_undefined(_type)) _type = self.__type;
		if (!struct_exists(self.__collection, _type)) return -1;
		var _collection_type = self.__collection[$ _type];
		if (!struct_exists(_collection_type, "sprites")) return -1;
		var _sprites = _collection_type[$ "sprites"];
		if (!struct_exists(_sprites, _action)) return -1;
		var _sprite = _sprites[$ _action];
		return _sprite;
	}
	/// @param {string} animation
	/// @param {bool} reset_if_same
    static play = function(_animation, _reset = true, _frame = 0) {
		if (_animation == "") return;
        if (self.__animation != _animation || _reset) {
            self.__index = _frame;
			self.__last_keyframe = _frame - 1;
			self.__last_index = _frame - 1;
			self.__wait_frames = _frame + 1;
        }
        self.__animation = _animation;
        self.__sprite = self.get_sprite();
		var _props = self.get_props(_animation);
		if (is_undefined(_props)) return;
		var _keyframe_mode = struct_exists(_props, "keyframes") && is_array(_props.keyframes) && array_length(_props.keyframes) > 0;
		self.__current_animation = {
			mode: _keyframe_mode ? ANIMATION_MODE.KEYFRAMES : ANIMATION_MODE.SPEED,
			speed: struct_exists(_props, "speed") ? _props.speed : 1,
			max_key: struct_exists(_props, "max_key") ? _props.max_key : undefined,
			loop_begin: struct_exists(_props, "loop_begin") ? _props.loop_begin : 0
		}
		return self;
    }
	/// @param {string} type
	/// @param {real} x
	/// @param {real} y
	/// @returns {AnimationController} self
    static draw = function(_type, _x, _y) {
		if (!self.__visible) return self;
		var _sprite = self.__sprite;
		if (is_undefined(_type)) {
			_type = self.__type;
		} else {
			_sprite = self.get_sprite(self.__animation, _type);
		}
		var _index = self.__frame;
		return self.__draw_sprite(_sprite, _index, _x, _y);
    }
	/// @param {string} action
	/// @param {string} type
	/// @param {real} index
	/// @param {real} x
	/// @param {real} y
	/// @returns {AnimationController} self
    static draw_action = function(_action, _type, _index, _x, _y) {
		if (!self.__visible) return self;
		var _sprite = self.get_sprite_from_action(_action, _type);
        self.__draw_sprite(_sprite, _index, _x, _y);    
		return self;
    }
	/// @param {Asset.Sprite} sprite
	/// @param {real} index
	/// @param {real} x
	/// @param {real} y
	/// @returns {AnimationController} self
	static __draw_sprite = function(_sprite, _index, _x, _y) {
		if (instance_exists(self.__owner)) {
			if (is_undefined(_x)) _x = floor(self.__owner.x);
			if (is_undefined(_y)) _y = floor(self.__owner.y);
		}
		var _xscale = self.__xscale;
		var _yscale = self.__yscale;
		var _angle = self.__angle;
		var _color = self.__color;
		var _alpha = self.__alpha;
		if (is_undefined(_sprite)) return self;
		if (!CollageIsImage(_sprite) && !sprite_exists(_sprite)) return self;
        draw_image_ext(_sprite, _index, _x, _y, _xscale, _yscale, _angle, _color, _alpha); 
		//log(string(_sprite))
		return self;
	}
	/// @returns {bool}
    static on_end = function() {
		if(self.__current_animation == undefined) return false;
		var _next_index = self.__index + self.__current_animation.speed * self.__speed;
		var _length = self.get_length();
        return (_next_index >= _length);
    }
	/// @returns {real}
	static get_length = function() {
		if (self.__current_animation.mode == ANIMATION_MODE.KEYFRAMES) {
			return self.__current_animation.max_key + 1;
		}
        if (CollageIsImage(self.__sprite)) {
			return self.__sprite.GetCount();
		}
		return sprite_get_number(self.__sprite);
		
	}
	/// @returns {bool}
	static is_playing = function(_animation) {
        return self.__animation == _animation;
    }
	/// @param {struct} data
	/// @returns {AnimationController} self
	static parse_data = function(_data, _return_self = true) {
        if (!is_struct(_data)) {log("crap");return;}
    
        if (struct_exists(_data, "type_combinations")) {
            self.add_type_combinations(_data.type_combinations);
        }
        
        if (struct_exists(_data, "speed")) {
            self.set_speed(_data.speed);    
        }
    
        if (struct_exists(_data, "list")) {
            var _animations = _data.list;
            for (var _i = 0, _len = array_length(_animations); _i < _len; _i++) {
                var _animation = _animations[_i];
                var _name = _animation.name;
                var _anim_data = _animation.properties;
            
                if (!is_struct(_anim_data)) continue;
            
                var _keyframes = [];
                if (struct_exists(_anim_data, "keyframes")) {
                    _keyframes = _anim_data.keyframes;
                }
            
                var _action = _name;
                if (struct_exists(_anim_data, "action")) {
                    _action = _anim_data.action;
                }
            
                var _loop_begin = 0;
                if (struct_exists(_anim_data, "loop_begin")) {
                    _loop_begin = _anim_data.loop_begin;
                }
                
                var _speed = 1;
                if (struct_exists(_anim_data, "speed")) {
                    _speed = _anim_data.speed;
                }
            
				var _index_events = [];
				
				if (struct_exists(_anim_data, "index_events")) {
                    _index_events = _anim_data.index_events;
                }
				
				var _key_events = [];
				
				if (struct_exists(_anim_data, "key_events")) {
                    _key_events = _anim_data.key_events;
                }
				
				var _shot_offset_x = 0;
				
				if (struct_exists(_anim_data, "shot_offset_x")) {
                    _shot_offset_x = _anim_data.shot_offset_x;
                }
				
				var _shot_offset_y = 0;
				
				if (struct_exists(_anim_data, "shot_offset_y")) {
                    _shot_offset_y = _anim_data.shot_offset_y;
                }
				
				//shot offsets. i know i can get the active animation here. 
				var _anim_data = {
                    action: _action,
                    keyframes: _keyframes,
                    loop_begin: _loop_begin,
					index_events: _index_events,
					shot_offset_x: _shot_offset_x,
					shot_offset_y: _shot_offset_y,
                    speed: _speed
                }
                self.add_animation(_name, _anim_data);
            }
        }
		if(_return_self)
			return self;
		else
			return _anim_data;
    }
	static clear = function() {
	    self.__collection = {};
	    self.__sprite = -1;
	    self.__index = 0; 
		self.__frame = 0;
	    self.__types = {
	        "normal": [""]
	    };
	    self.__actions = [];
		self.__animations = [];
	    self.__animation = "";
	    self.__type = "normal";
	    self.__props = {};
		self.__events = {};
		self.__current_animation = {
			mode: ANIMATION_MODE.SPEED,
			speed: 1,
			max_key: undefined
		}
		self.__last_keyframe = -1;
		self.__last_index = -1;
		return self;
	}
}