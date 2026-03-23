draw_sprite_ext(sprite_index, CURRENT_FRAME / 6, x, y, 2, 2, 0, c_white, 0.75);

var _rot_offset = new Vec2(4, 0);
_rot_offset = _rot_offset.rotate(CURRENT_FRAME * 6);
draw_sprite_ext(sprite_index, CURRENT_FRAME / 3.5, x + _rot_offset.x * 2, y + _rot_offset.y * 2, 1, 1, 0, c_white, 0.75);
_rot_offset = _rot_offset.rotate(CURRENT_FRAME * 5);
draw_sprite_ext(sprite_index, CURRENT_FRAME / 4, x + _rot_offset.x, y + _rot_offset.y, 1, 1, 0, c_white, 0.75);
_rot_offset = _rot_offset.rotate(CURRENT_FRAME * -12);
draw_sprite_ext(sprite_index, CURRENT_FRAME / 4.5, x + _rot_offset.x * 2.5, y + _rot_offset.y * 2.5, 1, 1, 0, c_white, 0.75);
_rot_offset = _rot_offset.rotate(CURRENT_FRAME * -5);
draw_sprite_ext(sprite_index, CURRENT_FRAME / 5, x + _rot_offset.x * 3, y + _rot_offset.y * 3, 1, 1, 0, c_white, 0.75);