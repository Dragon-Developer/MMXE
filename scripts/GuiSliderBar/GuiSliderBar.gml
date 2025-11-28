function GuiSlidingBar(_width, _height, _handle_padding = 4) : GuiProgressBar(_width, _height) constructor{
	setSize(_width, _height);
    setFlexDirection("row");
    setJustifyContent("end");
    setAlignItems("end");
	self.held_down = false;
	self.handle_offset_y = _handle_padding
	
	self.setMaxValue(_width - _height - _handle_padding);
	
	setProgressValue = function(_value) {
        progressValue = clamp(_value, 0, maxProgressValue);
        emitEvent("progress_update", progressValue);
		Handle.setMargin([0,handle_offset_y,maxProgressValue - progressValue,-handle_offset_y])
        refresh();
		return self;
    }
	
	Handle = new GuiButton(_height + _handle_padding, _height + _handle_padding);
	Handle.setFlexDirection("column");
	Handle.addEventListener("hover", function(_pos) {
		if !held_down return;
		
		if(!mouse_check_button(mb_left)) {
			held_down = false;
			return;
		}
		
		var _val = floor(((_pos.x / 2) - Handle.absoluteX / 2) - Handle.width / 4)
		
		progressValue += _val;
		
		progressValue = clamp(progressValue, 0, maxProgressValue);
		
		emitEvent("slide", progressValue);
	});
	Handle.addEventListener("click", function(_pos) {
		self.held_down = true;
	});
	Handle.addEventListener("mouseleave", function(_pos) {
		self.held_down = false;
	});
	Handle.setMargin([0,handle_offset_y,maxProgressValue - progressValue,-handle_offset_y])
	
	addChild(Handle)
	
	drawMe = function(_x, _y) {
		Handle.setMargin([0,handle_offset_y,maxProgressValue - progressValue,-handle_offset_y])
		
		
        if (sprite_exists(sprite)) {
            var _xscale = progressValue / maxProgressValue * width / sprite_get_width(sprite); 
            var _yscale = height / sprite_get_height(sprite);
            draw_sprite_ext(sprite, 0, floor(_x), floor(_y), _xscale, _yscale, 0, color, 1);
        }
		if (sprite_exists(backgroundSprite)) {
            var _xscale = width / sprite_get_width(backgroundSprite); 
            var _yscale = height / sprite_get_height(backgroundSprite);
            draw_sprite_ext(backgroundSprite, 0, floor(_x), floor(_y), _xscale, _yscale, 0, color, 1);
        }
    }
}