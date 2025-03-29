function NET_Manager() constructor {
	self.elements = {};
	static setElement = function(_key, _value) {
		elements[$ _key] = _value;
	}
	static getCount = function() {
		return struct_names_count(elements);	
	}
	static getKeys = function() {
		return struct_get_names(elements);	
	}
	static getElement = function(_key) {
		if (struct_exists(elements, _key)) {
			return elements[$ _key];	
		}
		return undefined;
	}
	static hasElement = function(_key) {
		return struct_exists(elements, _key);
	}
	static removeElement = function(_key) {
		struct_remove(elements, _key);	
	}
	static clearAll = function() {
		elements = {};	
	}
	static forEach = function(_method) {
		struct_foreach(elements, _method);	
	}
}