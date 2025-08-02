global.gui = new GuiRoot();
last_input = 0;

var _save = JSON.load(working_directory + "save.json");
if(_save == -1) return;
show_debug_message(_save)
global.player_data = _save.player_data;
global.settings = _save.settings;