function EntityComponentBase() constructor {
	self.parent = undefined;
	self.__tags = {};
	self.__constructor = -1;
	self.__id = -1;
	
	self.step_enabled = true;
	self.draw_enabled = true;
	self.serializer = new NET_Serializer();
	
	self.init = function() {}
	self.step = function() {}
	self.step_end = function() {}
	self.draw = function() {}
	self.draw_end = function() {}
	self.on_register = function() {}
	self.on_remove = function() {}
	
	self.get_instance = function() {
		return self.parent.get_instance();	
	}
	
	self.add_tags = function(_tags) {
		if (!is_array(_tags)) _tags = [_tags];
		array_foreach(_tags, function(_tag) {
			self.__tags[$ _tag] = true;
		});
	}
	self.has_tags = function(_tags) {
	    if (!is_array(_tags)) _tags = [_tags];
    
	    for (var _i = 0, _len = array_length(_tags); _i < _len; _i++) {
	        if (!struct_exists(self.__tags, _tags[_i])) {
	            return false;
	        }
	    }
    
	    return true;
	};
	
	self.set_constructor = function(_constructor) {
		self.__constructor = _constructor;	
	}
	self.get_constructor = function() {
		return self.__constructor;	
	}
	
	self.set_parent = function(_parent) {
		self.parent = _parent;	
	}
	
	self.publish = function(_event, _args) {
		if (is_undefined(self.parent)) return;
		self.parent.publish(_event, _args);
	}
	self.subscribe = function(_event, _callback) {
		if (is_undefined(self.parent)) return;
		self.parent.subscribe(_event, _callback);
	}
	self.save = function() {
		self.serializer.serialize();
	}
	self.load = function() {
		self.serializer.deserialize();
	}
}