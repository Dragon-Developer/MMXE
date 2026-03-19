draw_sprite(sprite_index, CURRENT_FRAME / 6, x, y);

var _rot_offset = new Vec2(6, 0);
_rot_offset = _rot_offset.rotate(CURRENT_FRAME * 8);
draw_sprite(sprite_index, CURRENT_FRAME / 3.5, x + _rot_offset.x, y + _rot_offset.y);