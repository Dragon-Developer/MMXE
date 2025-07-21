if(!directory_exists(game_save_id)){
	ini_open(game_save_id + "Savegame.ini");
	ini_write_string("Savegame", "deez", "nuts");
	ini_close();
} else {
}


global.gui = new GuiRoot();
last_input = 0;

// Always 255 on modern PCs;
fullSpace = 255;
// Here we use 31 as it's 15-bit max value.
colorSpace = 31;
// Calculate.
shader_set(shdr_snes_palette);
var scale = floor(fullSpace / colorSpace);
var deviation = floor(colorSpace / (fullSpace mod colorSpace));
shader_set_uniform_f(shader_get_uniform(shdr_snes_palette, "scale"), scale);
shader_set_uniform_f(shader_get_uniform(shdr_snes_palette, "deviation"), deviation);
shader_reset();

	Folder_Copy(program_directory + "\\datafiles", game_save_id, fa_none)

