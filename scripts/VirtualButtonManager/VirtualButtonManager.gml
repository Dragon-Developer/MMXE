function VirtualButtonManager() constructor {
	self.__vbutton_types = {};
	self.__vbutton_shape = {};
	
	self.__vbutton_types[$ "button"] = function(_input, _config) {
		var _verb = _config.verb;
		_input.button(_verb);	
	}
	self.__vbutton_types[$ "thumbstick"] = function(_input, _config) {
		var _verbs = _config.verb;
		_input.thumbstick(_verbs[0], _verbs[1], _verbs[2], _verbs[3], _verbs[4]);	
	}
	
	self.__vbutton_shape[$ "rectangle"] = function(_input, _config) {
		var _shape = _config.shape;
		_input.rectangle(_shape.x, _shape.y, _shape.x + _shape.width, _shape.y + _shape.height)
	}
	self.__vbutton_shape[$ "circle"] = function(_input, _config) {
		var _shape = _config.shape;
		_input.circle(_shape.x, _shape.y, _shape.radius);
	}
	
	self.__vbutton = [];
	
	self.__config = [
		{
			verb: [undefined, "left", "right", "up", "down"],
			type: "thumbstick",
			shape: {
				type: "circle",
				radius: 64,
				x: 96,
				y: 300,
			},
		},
		{
			verb: "atk",
			type: "button",
			shape: {
				type: "circle",
				radius: 32,
				x: 752-70-40,
				y: 312,
			},
		},
		{
			verb: "atk_heavy",
			type: "button",
			shape: {
				type: "circle",
				radius: 32,
				x: 752-40,
				y: 312,
			},
		},
	];
	static create = function() {
		if (!global.is_mobile) return;
		array_foreach(self.__config, function(_config, _index) {
			var _input = input_virtual_create();
			self.__vbutton[_index] = _input;
			self.__vbutton_shape[$ _config.shape.type](_input, _config);
			self.__vbutton_types[$ _config.type](_input, _config);
		});
	}
	static draw = function() {
		if (!global.is_mobile) return;
		draw_set_color(c_white);
		draw_set_alpha(0.7);
		input_virtual_debug_draw();
		draw_set_alpha(1);
	}
}