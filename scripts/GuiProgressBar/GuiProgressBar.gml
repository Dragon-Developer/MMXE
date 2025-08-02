function GuiProgressBar(_width, _height) : GuiContainer() constructor {
    setSize(_width, _height);
    setFlexDirection("row");
    setJustifyContent("center");
    setAlignItems("center");
    
    progressValue = 0;
	maxProgressValue = 100;
    
    textChild = new GuiText(""); 
    addChild(textChild);

    backgroundSprite = spr_gui_panel;
	setSprite(spr_gui_debug_9slice);

    setProgressValue = function(_value) {
        progressValue = clamp(_value, 0, maxProgressValue);
        emitEvent("progress_update", progressValue);
        refresh();
		return self;
    }
	
	setMaxValue = function(_value) {
		maxProgressValue = _value;
		refresh();
		return self;
	}

    setBackgroundSprite = function(_sprite) {
        backgroundSprite = _sprite;
        refresh();
        return self;
    }

    drawMe = function(_x, _y) {
		if (sprite_exists(backgroundSprite)) {
            var _xscale = width / sprite_get_width(backgroundSprite); 
            var _yscale = height / sprite_get_height(backgroundSprite);
            draw_sprite_ext(backgroundSprite, 0, floor(_x), floor(_y), _xscale, _yscale, 0, color, 1);
        }
        if (sprite_exists(sprite)) {
            var _xscale = progressValue / maxProgressValue * width / sprite_get_width(sprite); 
            var _yscale = height / sprite_get_height(sprite);
            draw_sprite_ext(sprite, 0, floor(_x), floor(_y), _xscale, _yscale, 0, color, 1);
        }
    }
}
