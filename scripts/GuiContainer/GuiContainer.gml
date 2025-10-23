function GuiContainer() : GuiBase() constructor {
    borderColors = {
		normal: #d0d0d0,
		hover: #d0d0d0	
	}
	children = [];
	sprite = spr_gui_pixel;
	index = 0;
	borderSprite = -1;
	borderIndex = 15;
	borderColor = -1;
	setColor(-1);
	focused = false;
	hover = false;
	scrollX = 0;
	scrollY = 0;
	scrollWidth = 0;
	scrollHeight = 0;
	scrollSpeed = 40;
	scrollEnabled = false;
	
	self.setScrollEnabled = function(_scroll) {
		self.scrollEnabled = _scroll;
		self.refresh();
		return self;
	}
	
	layoutManager = new GuiLayoutManager(self);
	refreshLayout = true;
	
	self.__mouseCursor = {
		normal: cr_default,
		hover: cr_default,
	};
	
	setBorderSprite = function(_sprite) {
		borderSprite = _sprite;
		refresh();
		return self;
	}
	
	setBorderIndex = function(_index) {
		borderIndex = _index;
		refresh();
		return self;
	}
	
	setBorderColor = function(_color) {
		borderColor = _color;
		refresh();
		return self;
	}
	
	setFlexWrap = function(_wrap) {
	    layoutManager.flexWrap = _wrap;
	    refresh();
	    return self;
	}
	
	setPadding = function(_array) {
		layoutManager.padding = {
			left: _array[0],
			top: _array[1],
			right: _array[2],
			bottom: _array[3]
		}	
		refresh();
		return self;
	}

	setPaddingSize = function(_size) {
		setPadding([_size, _size, _size, _size]);
		return self;
	}
	
	setFlexDirection = function(_flex_direction) {
		layoutManager.flexDirection = _flex_direction;
		refresh();
		return self;
	}
	
	setJustifyContent = function(_justify) {
		layoutManager.justifyContent = _justify;
		refresh();
		return self;
	}
	
	setAlignContent = function(_align) {
		layoutManager.alignContent = _align;
		refresh();
		return self;
	}
	
	setAlignItems = function(_align) {
		layoutManager.alignItems = _align;
		refresh();
		return self;
	}
	
	setGap = function(_gap) {
		layoutManager.gap = _gap;
		refresh();
		return self;
	}
	
	refresh = function() {
		refreshCache = true;	
		refreshLayout = true;
		if (!is_undefined(parent)) parent.refresh();
	}
	
	refreshChildren = function() {
		refreshCache = true;	
		refreshLayout = true;
		for (var _i = 0; _i < array_length(children); _i++) {
            children[_i].refreshChildren();
        }
	}
	
	rootStep = function() {
		if (refreshLayout) {
			childrenStep();
			calculateAbsolutePositions(); 
			calculateDrawPositions();
		}
	}

	layoutChildren = function() {
        if (!refreshLayout) return;
        
        layoutManager.layout();
        
        refreshLayout = false;
    };

	setMaximize = function() {
		setSize(display_get_gui_width(), display_get_gui_height());	
		refresh();
		return self;
	}
	
	setSprite = function(_sprite) {
		sprite = _sprite;
		refresh();
		return self;
	}
	
	setIndex = function(_index) {
		index = _index;
		refresh();
		return self;
	}

    addChild = function(_children) {
		if (!is_array(_children)) {
			_children = [_children];	
		}
		array_foreach(_children, function(_child) { 
			if (is_string(_child)) {
				_child = new GuiText(_child);	
			}
			var _index = array_get_index(children, _child);
			if (_index == -1) {
				array_push(children, _child);
			}
			_child.parent = self;
			_child.init();
		});
		refresh();
		return self;
    };
	
	clearChildren = function() {
		array_delete(children, 0, array_length(children));	
		refresh();
	}
    
	propagate = function(_event_name, _data) {
        for (var _i = 0; _i < array_length(children); _i++) {
            children[_i].propagate(_event_name, _data);
            children[_i].emitEvent(_event_name, _data);
        }
    };
	
	print = function(_level = 0) {
		var _result = string_repeat("--", _level) + printMe();
		for (var _i = 0; _i < array_length(children); _i++) {
            _result += children[_i].print(_level + 1)
        }
		return _result;
	}
	
	onHover = function(_pos) {
		if (!enabled) return;
		if (checkClick(_pos.x, _pos.y)) {
			if (!hover) {
				hover = true;
				emitEvent("mouseenter");
			}
			emitEvent("hover", _pos);
			refresh();
		} else if (hover) {
			hover = false;
			emitEvent("mouseleave");
			refresh();
		}
		
		for (var i = 0, _len = array_length(children); i < _len; i++) {
			// i need the damn child!
	        children[i].onHover(_pos, children[i]);
	    }
	}
	
	onClick = function(_pos) {
		if (!enabled) return;
		if (checkClick(_pos.x, _pos.y)) {
			if (!focused) {
				focused = true;
				emitEvent("focus");
			}
			emitEvent("click", _pos);
			refresh();
		} else if (focused) {
			focused = false;
			emitEvent("unfocus");
			refresh();
		}
		
		for (var i = 0, _len = array_length(children); i < _len; i++) {
	        if (!children[i].justChanged) children[i].onClick(_pos);
	    }
	}
	
	drawChildren = function(_x, _y) {
		for (var i = 0; i < array_length(children); i++) {
            children[i].draw(_x, _y);
        }
	}
	
	drawSprite = function(_x, _y, _sprite, _index, _color, _default_alpha = 1) {
		if (sprite_exists(_sprite) && _color != -1) {
			var _xscale = width / sprite_get_width(_sprite);
			var _yscale = height / sprite_get_height(_sprite);
			var _alpha = (usingCache) ? _default_alpha : alpha;
			draw_set_alpha(1);
			draw_sprite_ext(_sprite, _index, floor(_x), floor(_y), _xscale, _yscale, 0, _color, _alpha);
		}
	}
	
	drawMe = function(_x, _y) {
		drawSprite(_x, _y, sprite, index, color);
		drawSprite(_x, _y, borderSprite, borderIndex, borderColor);
	}

	freeSurface = function() {
		if (surf != -1 && surface_exists(surf)) {
			surface_free(surf);	
		}
		surf = -1;
	}
	
	calculateAbsolutePositions = function() {
		calculateAbsolutePosition();
		for (var _i = 0, _len = array_length(children); _i < _len; _i++) {
			children[_i].calculateAbsolutePositions();
		}
	}
	
	calculateDrawPositions = function() {
		calculateDrawPosition();
		for (var _i = 0, _len = array_length(children); _i < _len; _i++) {
			children[_i].calculateDrawPositions();
		}
	}

    draw = function() {
		if (enabled && visible) {
			if (usingCache) {
				var _refresh = refreshCache || !surface_exists(surf);
				if (_refresh) {
		            if (!surface_exists(surf)) {
		                surf = surface_create(width, height);
					}
					
		            var _previous_surf = surface_get_target();
					if (surface_exists(_previous_surf))
						surface_reset_target();
					surface_set_target(surf);
			            draw_clear_alpha(c_black, 0);
						gpu_push_state();
							gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
				            drawMe(0, 0);
				            drawDebug(0, 0);
				            drawChildren(0, 0);
						gpu_pop_state()
					surface_reset_target();
					
				
					if (surface_exists(_previous_surf))
						surface_set_target(_previous_surf);
				}
				var _pos = getDrawPosition();
				_pos.x = floor(_pos.x);
				draw_set_alpha(alpha);
				draw_set_color(c_black);
				gpu_push_state();
					gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
		            draw_surface(surf, _pos.x, _pos.y);
				gpu_pop_state();
				draw_set_alpha(1);
	        } else {
				var _pos = getDrawPosition();
	            drawMe(_pos.x, _pos.y);
	            drawDebug(_pos.x, _pos.y );
	            drawChildren(_pos.x , _pos.y);
	        }
	        refreshCache = false;
		} else {
			freeSurface();
		}
    };
	
	childrenStep = function() {
		layoutChildren();
	    for (var _i = 0, _len = array_length(children); _i < _len; _i++) {
	        children[_i].step();
			children[_i].justChanged = false;
	    }	
		updateScrollSize();
	}
	
    step = function() {
		emitEvent("step");
		if (hover && scrollEnabled) {
			var scrollDelta = mouse_wheel_up() - mouse_wheel_down(); 
			if (scrollDelta != 0) {
			    scrollBy(0, -scrollDelta * scrollSpeed);
			}
		}
	    childrenStep();
	};
	
	scrollBy = function(_dx, _dy) {
		scrollX = clamp(scrollX + _dx, 0, max(0, scrollWidth - width));
		scrollY = clamp(scrollY + _dy, 0, max(0, scrollHeight - height));
		refresh();
	}
	
	updateScrollSize = function() {
	    /*var maxWidth = 0;
	    var maxHeight = 0;
	    for (var _i = 0; _i < array_length(children); _i++) {
	        var child = children[_i];
	        maxWidth = max(maxWidth, child.x + child.width);
	        maxHeight = max(maxHeight, child.y + child.height);
	    }
	    scrollWidth = maxWidth;
	    scrollHeight = maxHeight;
		*/	
	}
	
	addEventListener("mouseenter", function() {
		setBorderColor(borderColors.hover);	
	});
	addEventListener("mouseleave", function() {
		setBorderColor(borderColors.normal);	
	});
	addEventListener("hover", function() {
		window_set_cursor(__mouseCursor.hover);
	});
}