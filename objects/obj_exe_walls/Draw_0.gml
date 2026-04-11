image_xscale = move_dir
draw_sprite_ext(sprite_index, 0, x, y - 240 + (CURRENT_FRAME * wave_speed) mod 240, move_dir, 1, 0, c_white, 1)
draw_sprite_ext(sprite_index, 0, x, y + (CURRENT_FRAME * wave_speed) mod 240, move_dir, 1, 0, c_white, 1)
draw_set_color(#ffe8ff)
draw_rectangle(x, y, x - 64 * move_dir, y + 240, false)