function log(_string){
	show_debug_message(_string);
	//if(variable_global_exists(global.logger)){
		LOG.print(_string);
	//}
}
function LogConsole() constructor {
	static print = function(_text) {
		show_debug_message(_text);
	}
	static close = function() {}
}
function LogFile() constructor {
	self.path = "log.txt";
	self.file = file_text_open_append(working_directory + self.path);
	
	static print = function(_text) {
		file_text_write_string(self.file, _text);
		file_text_writeln(self.file);
	}

	static close = function() {
			file_text_close(self.file);
		
	}
}