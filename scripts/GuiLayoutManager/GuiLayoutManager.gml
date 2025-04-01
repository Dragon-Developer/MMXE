function GuiLayoutManager(_container) constructor {
    container = _container;
    children = [];
    gap = 0;
    padding = { top: 0, right: 0, bottom: 0, left: 0 };
    flexDirection = "row";
    flexWrap = "nowrap";
    justifyContent = "start";
    alignItems = "start";
    alignContent = "start";

    layout = function() {
        var _children = array_filter(container.children, function(_child) { return _child.enabled; });
        var _count = array_length(_children);
    
		var _content_width = container.width - padding.left - padding.right;
		var _content_height = container.height - padding.top - padding.bottom;
        var _size = (flexDirection == "row" ? _content_width : _content_height);
		var _other_size = (flexDirection == "row" ? _content_height : _content_width);

        if (flexWrap == "nowrap") {
            layoutNoWrap(_children, _size, _other_size);
        } else {
            layoutWrap(_children, _size, _other_size);
        }
    };

    layoutNoWrap = function(_children, _size, _other_size, _parent_x = 0, _parent_y = 0) {
	    var _count = array_length(_children);
	    var _gap = gap;
	    var _total_fixed_size = 0;
	    var _flex_total = 0;

	    for (var _i = 0; _i < _count; _i++) {
	        var _child = _children[_i];
			if (_child.autoWidth && flexDirection == "row")
			|| (_child.autoHeight && flexDirection == "column") {
				_child.flexGrow = 1;
			}
	        if (_child.flexGrow > 0) {
	            _flex_total += _child.flexGrow;
	        } else {
		        if (flexDirection == "row") {
		            _total_fixed_size += (_child.width + _child.margin.left + _child.margin.right);
		        } else {
		            _total_fixed_size += (_child.height + _child.margin.top + _child.margin.bottom);
		        }
			}
	    }

	    _total_fixed_size += max(0, (_count - 1) * _gap);

	    var _remaining_size = max(0, _size - _total_fixed_size);

	    var _start = flexDirection == "row" ? padding.left : padding.top;
		var _end = flexDirection == "row" ? padding.right : padding.bottom;
		var _parent_offset = flexDirection == "row" ? _parent_x : _parent_y;
		
		var _pos = _start;
		
	    var _child_size = (_flex_total > 0) ? (_remaining_size / _flex_total) : 0;
		var _children_size = _child_size*_flex_total;
	    if (justifyContent == "center") {
	        _pos = _start + (_size - _total_fixed_size - _children_size ) / 2;
	    } else if (justifyContent == "end") {
	        _pos = container.width - _total_fixed_size - _children_size - _end;
	    } else if (justifyContent == "space-between" && _count > 1) {
	        _gap = (_size - _total_fixed_size - _children_size) / (_count - 1);
	    } else if (justifyContent == "space-around" && _count > 0) {
	        _gap = (_size - _total_fixed_size - _children_size) / _count;
	        _pos = _gap / 2;
	    } else if (justifyContent == "space-evenly" && _count > 0) {
	        _gap = (_size - _total_fixed_size - _children_size) / (_count + 1);
	        _pos = _gap;
	    }
		container.scrollWidth = 0;
		container.scrollHeight = 0;
	    for (var _i = 0; _i < _count; _i++) {
	        var _child = _children[_i];
	        if (!_child.enabled) continue;
			if (_child.autoHeight && flexDirection == "row")
			|| (_child.autoWidth && flexDirection == "column") {
				_child.alignSelf = "stretch";
			}
	        var _align = !is_undefined(_child.alignSelf) ? _child.alignSelf : alignItems;
	        if (flexDirection == "row") {
	            _pos += _child.margin.left;
	            _child.x = _pos;

	            if (_child.flexGrow > 0) {
	                _child.width = (_child.flexGrow / _flex_total) * _remaining_size;
	            }

	            _pos += _child.width + _child.margin.right + _gap;
				container.scrollWidth = max(container.scrollWidth, _pos + 2*padding.left + padding.right);
	        } else {
	            _pos += _child.margin.top;
	            _child.y = _pos + padding.top;


	            if (_child.flexGrow > 0) {
	                _child.height = (_child.flexGrow / _flex_total) * _remaining_size;

	            }

	            _pos += _child.height + _child.margin.bottom + _gap;
				container.scrollHeight = max(container.scrollHeight, _pos + 2*padding.top + padding.bottom);
	        }

	        handleAlignment(_child, _align, _other_size, padding.top);
	    }
	};


	layoutWrap = function(_children, _size, _other_size) {
	    var _count = array_length(_children);
	    var _line_pos = 0;
		var _pos = 0;
	    var _line_size = 0;
	    var _line_items = [];
	    var _lines = [];
	    for (var _i = 0; _i < _count; _i++) {
	        var _child = _children[_i];
	        if (!_child.enabled) continue;

	        var _child_size = (flexDirection == "row") ? _child.width : _child.height;
	        var _child_other_size = (flexDirection == "row") ? _child.height : _child.width;
	        var _child_margin_size = (flexDirection == "row") 
	            ? _child.margin.left + _child.margin.right
	            : _child.margin.top + _child.margin.bottom;
			var _gap_total = max(0, (array_length(_line_items) - 1) * gap);

	        if (_pos + _child_size + _child_margin_size + _gap_total > _size) {
	            array_push(_lines, { items: _line_items, size: _line_size, pos: _line_pos });

	            _line_pos += _line_size;
	            _pos = 0;
	            _line_size = 0;
	            _line_items = [];
	        }

	        _pos += _child_size + _child_margin_size;
	        _line_size = max(_line_size, _child_other_size + _child_margin_size);
	        array_push(_line_items, _child);
	    }

	    if (array_length(_line_items) > 0) {
	        array_push(_lines, { items: _line_items, size: _line_size, pos: _line_pos });
	    }

	    applyAlignmentsToLines(_lines, _size, _other_size);
	};

	handleAlignment = function(_child, _align, _other_size, _line_pos) {
	    if (_align == "center") {
	        if (flexDirection == "row") {
	            _child.y = _line_pos + (_other_size - _child.height) / 2;
	        } else {
	            _child.x = _line_pos + _other_size / 2 - _child.width / 2;
	        }
	    } else if (_align == "end") {
	        if (flexDirection == "row") {
	            _child.y = _line_pos + (_other_size - _child.height);
	        } else {
	            _child.x = _line_pos + _other_size - _child.width;
	        }
	    } else if (_align == "stretch") {
	        if (flexDirection == "row") {
	            _child.height = _other_size;
	            _child.y = _line_pos;
	        } else {
	            _child.width = _other_size;
	            _child.x = _line_pos;
	        }
	    } else if (_align == "start") {
	        if (flexDirection == "row") {
	            _child.y = _line_pos;
	        } else {
	            _child.x = _line_pos;
	        }
	    }
	};

	
	applyAlignmentsToLines = function(_lines, _size, _other_size) {
	    var _total_size = 0;
		var _gap = gap;
		var _len = array_length(_lines);
	    for (var _l = 0; _l < _len; _l++) {
	        _total_size += _lines[_l].size;
	    }
	    var _offset = flexDirection == "row" ? padding.top : padding.left;
	    if (alignContent == "center") {
	        _offset = (_other_size - _total_size) / 2;
	    } else if (alignContent == "end") {
	        _offset += _other_size - _total_size;
	    } else if (alignContent == "space-between" && _len > 1) {
	        _gap = (_other_size - _total_size) / (_len - 1);
	    } else if (alignContent == "space-around" && _len > 0) {
	        _gap = (_other_size - _total_size) / _len;
	        _offset += _gap / 2;
		}

	    for (var _l = 0; _l < _len; _l++) {
	        var _line = _lines[_l];
	        applyAlignmentsToLine(_line.items, _size, _line.size, _offset);
	        _offset += _line.size + _gap;
	    }
	};

	applyAlignmentsToLine = function(_line_items, _size, _line_size, _py) {
	    var _total_children_size = 0;
	    var _count = array_length(_line_items);

	    var _gap = gap;
	    var _total_fixed_size = 0;
	    var _flex_total = 0;

	    for (var _i = 0; _i < _count; _i++) {
	        var _child = _line_items[_i];
	        if (_child.flexGrow > 0) {
	            _flex_total += _child.flexGrow;
	        } else {
		        if (flexDirection == "row") {
		            _total_fixed_size += (_child.width + _child.margin.left + _child.margin.right);
		        } else {
		            _total_fixed_size += (_child.height + _child.margin.top + _child.margin.bottom);
		        }
			}
	    }

	    _total_fixed_size += max(0, (_count - 1) * _gap);

	    var _remaining_size = max(0, _size - _total_fixed_size);
		
		
	    var _child_size = (_flex_total > 0) ? (_remaining_size / _flex_total) : 0;
		var _children_size = _child_size*_flex_total;


	    var _start = flexDirection == "row" ? padding.left : padding.top;
	    var _end = flexDirection == "row" ? padding.right : padding.bottom;
		var _offset = _start;
		 
	    if (justifyContent == "center") {
	        _offset = _start + (_size - _total_fixed_size - _children_size) / 2;
	    } else if (justifyContent == "end") {
	        _offset = _size - _total_fixed_size - _children_size - _end;
	    } else if (justifyContent == "space-between" && _count > 1) {
	        _gap = (_size - _total_fixed_size) / (_count - 1);
	    } else if (justifyContent == "space-around" && _count > 0) {
	        _gap = (_size - _total_fixed_size - _children_size) / _count;
	        _offset = _gap / 2;
	    } else if (justifyContent == "space-evenly" && _count > 0) {
	        _gap = (_size - _total_fixed_size - _children_size) / (_count + 1);
	        _offset = _gap;
	    }

	    for (var _i = 0; _i < _count; _i++) {
	        var _child = _line_items[_i];
			if (_child.autoHeight && flexDirection == "row")
			|| (_child.autoWidth && flexDirection == "column") {
				_child.alignSelf = "stretch";
			}
	        var _align = !is_undefined(_child.alignSelf) ? _child.alignSelf : alignItems;
	        if (flexDirection == "row") {
				_child.x = _offset;
				_offset += _child.margin.left + _child.width + _child.margin.right + _gap; 
	        } else {
	            _child.y = _offset;
	            _offset += _child.margin.top + _child.height + _child.margin.bottom + _gap;
	        }

	        handleAlignment(_child, _align, _line_size, _py);
	    }
	};

}
