function log(_string, _stack = global.stacktracking, _stacklength = 1){
	
	show_debug_message(_string);
	LOG.print(_string);
	
	var _msg = "";
	if(_stack){
		var _a = debug_get_callstack(_stacklength + 1);
	    for (var i = 1; i < array_length(_a); i++)
	    {
			_msg += string(_a[i]);
	    }
		show_debug_message(_msg);
		LOG.print(_msg);
	}
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