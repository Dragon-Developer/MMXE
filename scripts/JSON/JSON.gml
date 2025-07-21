function JSON() constructor {
	static save = function(_struct, _filename) {
	  // We stringify the struct itself into JSON formatting
	  var _json = json_stringify(_struct);
	  // We get the size of our stringified struct, in raw bytes
	  var _size = string_byte_length(_json);
	  // We create a buffer to store our string
	  var _buff = buffer_create(_size, buffer_fixed, 1);
	  // We write to our buffer with the whole string
	  buffer_write(_buff, buffer_text, _json);
	  // We then save it
	  buffer_save(_buff, _filename);
	  // And just a bit of a cleanup, by freeing the buffer!
	  buffer_delete(_buff);
	}

	static load = function(_filename) {
	  // We load in the file
	  var _buff = buffer_load(_filename);
	  //if the buffer does not exist, return -1 and bail
	  if(_buff == -1){
		return -1;
	  }
	  // We get the json from the buffer
	  var _json = buffer_read(_buff, buffer_text);
	  // We free the buffer, since we don't need it now. As we've extracted the whole string
	  buffer_delete(_buff);
	  // We convert the json into a struct
	  var _struct = json_parse(_json);
	  // We then return it as a handle
	  return _struct;
	}
}

new JSON();