
/*shader_set(shdr_snes_palette);
var scale = floor(fullSpace / colorSpace);
log(scale)
var deviation = floor(colorSpace / (fullSpace mod colorSpace));
shader_set_uniform_f(shader_get_uniform(shdr_snes_palette, "scale"), scale);
shader_set_uniform_f(shader_get_uniform(shdr_snes_palette, "deviation"), deviation);
draw_surface_stretched(application_surface, 0,0, GAME_W, GAME_H);
shader_reset();*/
global.gui.draw();