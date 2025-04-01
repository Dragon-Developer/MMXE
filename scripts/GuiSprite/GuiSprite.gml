function GuiSprite(_sprite) : GuiBase() constructor {
    sprite = -1;
	index = 0;
	flipX = false;
	setSprite = function(_sprite = -1) {
		sprite = _sprite;
		width = getContentWidth();
		height = getContentHeight();
		refresh();
		return self;
	}
	
	setFlipX = function(_flip) {
		flipX = _flip;
		refresh();
		return self;
	}
	
	setIndex = function(_index) {
		index = _index;
		refresh();
		return self;
	}

	getContentWidth = function() {
		return sprite_exists(sprite) ? sprite_get_width(sprite) : 0;
	}
	
	getContentHeight = function() {
		return sprite_exists(sprite) ? sprite_get_height(sprite) : 0;
	}

    drawMe = function() {
		if (!enabled) return;
		var _pos = getDrawPosition();
		if (sprite_exists(sprite)) {
			draw_set_alpha(alpha);
			var _xscale = 1;
			var _x = floor(_pos.x);
			var _y = floor(_pos.y);
			if (flipX) {
				_xscale = -1;
				_x += getContentWidth();
			}
			draw_sprite_ext(sprite, index, _x, _y, _xscale, 1, 0, c_white, 1);  
		}
    };

	setSprite(_sprite);
}