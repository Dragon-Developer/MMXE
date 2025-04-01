function GuiParser() constructor {
	setters = {
        borderSprite: "setBorderSprite",
		sprite: "setSprite",
        flexWrap: "setFlexWrap",
        padding: "setPadding",
        paddingSize: "setPaddingSize",
        flexDirection: "setFlexDirection",
        justifyContent: "setJustifyContent",
        alignContent: "setAlignContent",
        alignItems: "setAlignItems",
        gap: "setGap",
        autoWidth: "setAutoWidth",
        autoHeight: "setAutoHeight",
        flexGrow: "setFlexGrow",
        alpha: "setAlpha",
        margin: "setMargin",
        marginSize: "setMarginSize",
        maximize: "setMaximize",
		color: "setColor",
		width: "setWidth",
		height: "setHeight",
		title: "setTitle",
		text: "setText",
		usingCache: "setUsingCache"
    };
	hashSetters = {};
	struct_foreach(setters, function(_key, _value) {
		hashSetters[$ _key] = variable_get_hash(_value);
	});
	formatters = {
	    color: function(value) {
	        if (string_starts_with(value, "rgb")) {
	            var match = value;
	            match = string_delete(match, 1, 4); 
	            match = string_delete(match, string_length(match), 1);

	            var rgbValues = string_split(match, ",");
	            var r = real(rgbValues[0]);
	            var g = real(rgbValues[1]);
	            var b = real(rgbValues[2]);

	            return make_color_rgb(r, g, b);
	        }
	        else if (string_starts_with(value, "#")) {
	            var hex = string_delete(value, 1, 1);
	            var r = real("0x" + string_copy(hex, 1, 2));
	            var g = real("0x" + string_copy(hex, 3, 2));
	            var b = real("0x" + string_copy(hex, 5, 2));

	            return make_color_rgb(r, g, b);
	        }
	        return value;
	    },
		sprite: function(sprite) {
			return asset_get_index(sprite);	
		}
	};

	static loadFile = function(_filename) {
		// We load in the file
		var _buff = buffer_load(_filename);
		// We get the json from the buffer
		var _json = buffer_read(_buff, buffer_text);
		// We free the buffer, since we don't need it now. As we've extracted the whole string
		buffer_delete(_buff);
		return _json;
	} 
	static parseFile = function(_filename) {
		return parseString(loadFile(_filename));
	}
	static parseString = function (_string) {
		try {
			return createGuiElement(json_parse(_string));
		} catch (err) {
			show_debug_log("Error while parsing GUI json.")	
		}
    } 
	static applyGuiElement = function(_instance, _data) {
		var _keys = struct_get_names(_data);
        for (var _i = 0; _i < array_length(_keys); _i++) {
            var _key = _keys[_i];
			switch (_key) {
				case "type":
				case "children":
				case "repeat":
				
					break;
				case "onClick":
					var _value = _data[$ _key];
					_instance.addEventListener("click", _value);
					break;
				default:
					var _setter_hash = hashSetters[$ _key];
					var _setter_func = undefined;
					var _value = _data[$ _key];
	                if (!is_undefined(_setter_hash)) {
						_setter_func = struct_get_from_hash(_instance, _setter_hash);
					}
					if (!is_undefined(_setter_func)) {
	                    if (struct_exists(self.formatters, _key)) {
	                        _value = self.formatters[$ _key](_value);
	                    }
	                    _setter_func(_value);
	                } else {
						var _inst_value = _instance[$ _key];
						if (is_instanceof(_inst_value, GuiBase)) {
							applyGuiElement(_inst_value, _value);
						} else {
							show_debug_message("Unknown property " + _key);
						}
					}
			}
        }

        if (struct_exists(_data, "children")) {
            var _children = _data.children;
			if (is_array(_children)) {
	            for (var _j = 0; _j < array_length(_children); _j++) {
					var _child_data = _children[_j];
					_child_data[$ "repeat"] ??= 1;
					repeat(_child_data[$ "repeat"]) {
		                var _child = createGuiElement(_child_data);
		                if (!is_undefined(_instance)) {
		                    _instance.addChild(_child);
		                }
					}
	            }
			}
        }
		return _instance;
	}
    static createGuiElement = function(_data) {
        var _instance;
        switch (_data.type) {
            case "GuiRoot": _instance = new GuiRoot(); break;
            case "GuiFrame": _instance = new GuiFrame(); break;
            case "GuiButton": _instance = new GuiButton(); break;
            default:
                show_debug_message("Unknown type: " + _data.type);
                return undefined;
        }
		return applyGuiElement(_instance, _data);
    }
}
