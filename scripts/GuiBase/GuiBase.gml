function GuiBase() constructor {
	static _id = 0;
    x = 0;
    y = 0;
	absoluteX = 0;
	absoluteY = 0;
	drawX = 0;
	drawY = 0;
    width = 0;
    height = 0;
	color = c_white;
    visible = true;
	alpha = 1;
    events = {}; 
    parent = undefined;
	debug = false;
	enabled = true;
    halign = fa_left;
	valign = fa_top;
	anchorX = 0;
	anchorY = 0;
	surf = -1;
	name = $"{_id++}";
	usingCache = false;
	refreshCache = false;
	alignSelf = undefined;
	debugSprite = spr_gui_debug_9slice;
	debugColor = c_red;
	flexGrow = 0;
	justChanged = false;

	margin = { left: 0, top: 0, right: 0, bottom: 0 };

	autoWidth = false;
	autoHeight = false;
	
	setAutoWidth = function(_auto) {
		autoWidth = _auto;
		refresh();
		return self;
	}
	
	setAutoHeight = function(_auto) {
		autoHeight = _auto;
		refresh();
		return self;
	}

	setFlexGrow = function(_flex) {
		flexGrow = _flex;
		refresh();
		return self;
	}

	setAlpha = function(_alpha) {
		alpha = _alpha;
		refresh();
		return self;
	}

	setMargin = function(_array) {
		margin = {
			left: _array[0],
			top: _array[1],
			right: _array[2],
			bottom: _array[3]
		}	
		return self;
	}

	setMarginSize = function(_size) {
		setMargin([_size, _size, _size, _size]);
		return self;
	}

	refresh = function() {
		refreshCache = true;	
	}
	refreshChildren = function() { 
		refresh(); 
	}
    setAlignSelf = function(_align) {
        alignSelf = _align;
        refresh();
        return self;
    };
	
    setAlignment = function(_halign = undefined, _valign = undefined) {
		if (!is_undefined(_halign)) {
			halign = _halign;
		}
		if (!is_undefined(_valign)) {
			valign = _valign;
		}
        refresh();
        return self;
    }
	
	setUsingCache = function(_value) {
		usingCache = _value;
		return self;
	}
	
	setAnchor = function(_x = 0, _y = 0) {
		anchorX = _x;
		anchorY = _y;
        refresh();
		return self;
	}
	
	getContentWidth = function() {
        return width;    
    }

    getContentHeight = function() {
        return height;
    }
	
	setEnabled = function(_enabled) {
		enabled = _enabled;
		justChanged = true;
        refresh();
		return self;
	}
	
	setSize = function(_width, _height) {
		width = _width;
		height = _height;
        refresh();
		return self;
	}
	
	setWidth = function(_width) {
		width = _width;
		refresh();
		return self;
	}
	
	setHeight = function(_height) {
		height = _height;
		refresh();
		return self;
	}
	
    setPosition = function(_x, _y) {
        x = _x;
        y = _y;
        refresh();
		return self;
    };
	
	setColor = function(_color) {
		color = _color;
        refresh();
		return self;
	}

	calculateAbsolutePosition = function() {	
		if (is_undefined(parent)) {
			absoluteX = x;
			absoluteY = y;
			return;
		} 
		absoluteX = parent.absoluteX - parent.scrollX + x;
		absoluteY = parent.absoluteY - parent.scrollY + y;
	}
	
	calculateDrawPosition = function() {
		if (is_undefined(parent) || parent.usingCache) {
			drawX = x;
			drawY = y;
			return;
		}
		drawX = parent.drawX + x ;
		drawY = parent.drawY + y ;
	}
	
	calculateDrawPosition = function() {
	    if (is_undefined(parent) || parent.usingCache) {
	        drawX = x;
	        drawY = y;
			if (!is_undefined(parent)) {
				drawX -= parent.scrollX;
				drawY -= parent.scrollY;
			}
	        return;
	    }
	    drawX = parent.drawX - parent.scrollX + x;
	    drawY = parent.drawY - parent.scrollY + y;
	}

	
	calculateAbsolutePositions = function() {
		calculateAbsolutePosition();
	}
	
	calculateDrawPositions = function() {
		calculateDrawPosition();
	}

	getDrawPosition = function() {
		/*
		var _parent_position = { x: 0, y: 0 };
		var _anchor_offset = { x: 0, y: 0 };
		if (!is_undefined(parent)) {
			if (!_for_draw || (!_ignore_parent_pos && !parent.usingCache)) {
				_parent_position = parent.getAbsolutePosition(_ignore_parent_pos, _for_draw);
			}
			_anchor_offset = {
				x: floor((parent.width - width) * anchorX),
				y: floor((parent.height - height) * anchorY)
			}
		}
		return {
            x: floor(_parent_position.x + _anchor_offset.x + x + margin.left),
            y: floor(_parent_position.y + _anchor_offset.y + y + margin.top)
		}*/
		return {
			x: drawX,
			y: drawY
		}
	}
	
    addEventListener = function(_event_name, _callback) {
        events[$ _event_name] ??= [];
        array_push(events[$ _event_name], _callback);
		return self;
    };
    
    emitEvent = function(_event_name, _data) {
		if (!enabled) return;
        if (struct_exists(events, _event_name)) {
            for (var i = 0; i < array_length(events[$ _event_name]); i++) {
                events[$ _event_name][i](_data);
            }
        }
    };
	
	propagate = function() {}
    
    checkClick = function(mx, my) {
        return point_in_rectangle(mx - absoluteX, my - absoluteY, 0, 0, width, height);
    };

    onClick = function(_pos) {
		if (!enabled) return;
		emitEvent("click", _pos);
        refresh();
    };
	
	onHover = function(_pos) {
		if (!enabled) return;
		refresh();
	}

    invalidate = function() {
    };

    draw = function() {
		if (!enabled) return;
		if (!visible) return;
		drawMe();
		drawDebug();
    };
	
	drawDebug = function() {
		if (!debug) return;
		var _pos = getDrawPosition();
		draw_set_color(c_red);
		draw_set_alpha(1);
		var _x = _pos.x;
		var _y = _pos.y;
		draw_sprite_stretched_ext(debugSprite, 0, _x, _y, width, height, c_red, 1);
		//draw_text_color(_x, _y, name, c_white, c_white, c_white, c_white, 1);
		
    };
	
	drawMe = function(_x, _y) {}

	init = function() {}

    step = function() {};

    setVisibility = function(_visibility) {
        visible = _visibility;
    };

    getVisibility = function() {
        return visible;
    };

    removeEventListener = function(event_name, callback) {
        if (struct_exists(events, event_name)) {
            var index = array_find_index(events[$ event_name], callback);
            if (index != -1) {
                array_delete(events[$ event_name], index, 1);
            }
        }
    };
	
	addEventListener("debug", function(_debug) {
		debug = _debug;
        refresh();
	});
	
	printMe = function() {
		return string({ name, width, height, x, y, type: string(instanceof(self)), _id}) + "\n";
	}
	
	returnSelf = function() {
		return { name, width, height, x, y, type: string(instanceof(self))};
	}
	
	print = function(_level = 0) {
		return string_repeat("--", _level) + printMe();	
	}
	
	setName = function(_name){
		name = _name;
	}
}
