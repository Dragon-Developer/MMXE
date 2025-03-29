function EventBus() constructor {
    self.__events = {};

    self.subscribe = function(_event, _callback) {
        if (!struct_exists(self.__events, _event)) {
            self.__events[$ _event] = [];
        }
        array_push(self.__events[$ _event], _callback);
    };

    self.publish = function(_event, _args) {
        if (struct_exists(self.__events, _event)) {
            var _callbacks = self.__events[$ _event];
            array_foreach(_callbacks, method({ args: _args }, function(_callback) {
                _callback(args);
            }));
        }
    };
	
	self.unsubscribe = function(_event, _callback) {
        if (struct_exists(self.__events, _event)) {
            var _callbacks = self.__events[$ _event];
            var _index = array_get_index(_callbacks, _callback);
            if (_index != -1) {
                array_delete(_callbacks, _index, 1);
            }
        }
    };

    self.unsubscribe_all = function(_instance) {
        var _keys = struct_get_names(self.__events);
		for (var _i = 0, _len = array_length(_keys); _i < _len; _i++) {
			var _event = _keys[_i];
            var _callbacks = self.__events[$ _event];
            var _filtered = array_filter(_callbacks, method({ instance: _instance }, function(_callback) {
                return method_get_self(_callback) != instance;
            }));
            self.__events[$ _event] = _filtered;
        };
    };
}
