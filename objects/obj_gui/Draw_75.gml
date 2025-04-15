shader_set(shdr_snes_palette);
shader_set_uniform_f(shader_get_uniform(shdr_snes_palette, "PrecisionCutoff"), 255 / 32);
draw_surface_stretched(application_surface, 0, 0, GAME_W, GAME_H);
shader_reset();