function GuiText(_text) : GuiBase() constructor {
    font = fnt_default;
	__cursorPosition = 0;
	__cursorVisible = false;
	
	setCursorPosition = function(_position) {
		self.__cursorPosition = _position;
		refresh();
		return self;
	}
	setCursorVisible = function(_visible) {
		self.__cursorVisible = _visible;
		refresh();
		return self;
	}
	
	setText = function(_text) {
		text = _text;
		width = getContentWidth();
		height = getContentHeight();
		refresh();
		return self;
	}
	
	getText = function(){
		return text;
	}

    setFont = function(_font) {
        font = _font;
		setText(text);
		refresh();
        return self;
	}

	getContentWidth = function() {
		draw_set_font(font);
		return string_width(text) ;
	}
	
	getContentHeight = function() {
		draw_set_font(font);
		return string_height(text + " ");
	}

    drawMe = function() {
		if (!enabled) return;
		if (!visible) return;
		var _pos = getDrawPosition();
        //draw_set_font(font);
		//draw_set_halign(fa_left);
		//draw_set_valign(fa_top);
        //draw_text_color(floor(_pos.x), floor(_pos.y), text, color, color, color, color, alpha);
		draw_string_condensed(text, floor(_pos.x), floor(_pos.y) + 4)
		var _copy = string_copy(text, 1, __cursorPosition);
		var _pos_offset = string_width(_copy);
		if (__cursorVisible) {
			draw_text_color(floor(_pos.x + _pos_offset), floor(_pos.y), 
				"|", color, color, color, color, alpha)
		}
    };

    step = function() {
    };
	
	setText(_text);
}