#macro ENTITY_LOG_ENABLED false

function Entity() constructor {
	self.__components = [];
	self.__instance = other.id;
	self.__event_bus = new EventBus();

	static get_instance = function() {
		return self.__instance;	
	}
	static find = function(_tags) {
	    for (var _i = 0, _len = array_length(self.__components); _i < _len; _i++) {
	        var _component = self.__components[_i];
			if (_component.has_tags(_tags)) return _component;
	    }
	    return undefined;
	};
	static find_all = function(_tags) {
	    var _results = [];
	    for (var _i = 0, _len = array_length(self.__components); _i < _len; _i++) {
	        var _component = self.__components[_i];
			if (_component.has_tags(_tags)) array_push(_results, _component);
	    }
	    return _results;
	};
	static get = function(_constructor) {
		for (var _i = 0, _len = array_length(self.__components); _i < _len; _i++) {
			var _component = self.__components[_i];
			if (_component.get_constructor() == _constructor) {
				return _component;
			}
		}
		return undefined;
	}
	static add = function(_constructors) {
		if (!is_array(_constructors)) _constructors = [_constructors];
		array_foreach(_constructors, function(_constructor) {
			var _new_component = new _constructor();
			if (ENTITY_LOG_ENABLED) show_debug_message("Added: " +  instanceof(_new_component));
			_new_component.set_constructor(_constructor);
			_new_component.set_parent(self);
			_new_component.on_register();
			array_push(self.__components, _new_component);
			ENTITIES.cache_component(_new_component);
			self.publish("components_update");
		});
	}
	static remove = function(_constructor) {
		for (var _i = 0, _len; _i < array_length(self.__components); _i++) {
			var _component = self.__components[_i];
			if (is_instanceof(_component, _constructor)) {
				_component.on_remove();
				array_delete(self.__components, _i, 1);
				ENTITIES.remove_component(_component);
				self.publish("components_update");
				self.__event_bus.unsubscribe_all(_component);
				if (ENTITY_LOG_ENABLED) show_debug_message("Removed: " +  instanceof(_component));
				_i--;
				return;
			}
		}
		return false;
	}
	static pause = function(_value) {
		array_foreach(self.__components, method({ value: _value }, function(_component) {
			_component.step_enabled = !value;
		}));
	}
	static init = function() {
		array_foreach(self.__components, function(_component) {
			_component.init();
		});
	}
	static step = function() {
		array_foreach(self.__components, function(_component) {
			_component.step();
		});
	}
	static step_end = function() {
		array_foreach(self.__components, function(_component) {
			_component.step_end();
		});
	}
	static draw = function() {
		array_foreach(self.__components, function(_component) {
			if (_component.draw_enabled) _component.draw();
		});
	}
	static draw_end = function() {
		array_foreach(self.__components, function(_component) {
			_component.draw_end();
		});
	}
	static publish = function(_event, _args) {
		self.__event_bus.publish(_event, _args);	
	}
	static subscribe = function(_event, _callback) {
		self.__event_bus.subscribe(_event, _callback);	
	}
}