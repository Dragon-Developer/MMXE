alarm[0] = 1
end_point = new Vec2(64, 0);

close_enough = false;
player_grabbing = false;
grip_range = 4;
player = undefined;

pal = new Palette();

pal.setBaseColorByHex(0, #FF0000)
pal.setBaseColorByHex(1, #FFFF00)
pal.setBaseColorByHex(2, #00FF00)
pal.setPaletteColorByHex(1, global.availible_characters[global.character_index].zipline_palette[0])
pal.setPaletteColorByHex(2, global.availible_characters[global.character_index].zipline_palette[1])
pal.setPaletteColorByHex(0, global.availible_characters[global.character_index].zipline_palette[2])

var _incline = end_point.y / end_point.x;
var _vertical_offset = (0) * _incline

_top_point = (end_point.y < 0 ? y : y + end_point.y) - grip_range + _vertical_offset
_bottom_point = (end_point.y > 0 ? y : y + end_point.y) + grip_range + _vertical_offset
_left_point = (end_point.x > 0 ? x : x + end_point.x) - grip_range
_right_point = (end_point.x < 0 ? x : x + end_point.x) + grip_range