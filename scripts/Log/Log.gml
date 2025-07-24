function log(_string, _stack = false, _stacklength = 5){
	var _msg = "";
	if(_stack){
		var _a = debug_get_callstack(_stacklength);
	    for (var i = 0; i < array_length(_a); i++)
	    {
	        //show_debug_message(_a[i]);
			_msg += _a[i]
	    }
	}
	_string = string(_string) + _msg;
		
	show_debug_message(_string);
	LOG.print(_string);
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