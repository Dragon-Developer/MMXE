function NET_InstanceManager() constructor {
	self.array = [];
	self.dictionary = {};
	self.lastSavedSize = 0;
	self.lastID = 0;
	self.destroyEnabled = false;
	self.destroyWaiting = [];
	static exists = function(_inst) {
		return !is_undefined(_inst) && instance_exists(_inst) && _inst.active;
	}
	static saveAllInstances = function() {
		self.destroyEnabled = false;
		self.lastSavedSize = array_length(self.array);
		array_foreach(self.array, function(_instance) {
			_instance.serializer.serialize();
		});
	}
	static restoreAllInstances = function() {
		self.destroyEnabled = true;
		var _length = self.lastSavedSize;
		for (var i = 0; i < _length; i++) {
			var _inst = self.array[i];
			_inst.serializer.deserialize();
		}
		var _current_length = array_length(self.array);
		for (var i = _length; i < _current_length; i++) {
			instance_destroy(self.array[i]);	
		}
		var _count = _current_length - _length;
		array_delete(self.array, _length, _count);
	}
	static destroy = function(_inst) {
		_inst.destroy();
		_inst.visible = false;
		_inst.active = false;
		if (!destroyEnabled) {
			array_push(self.destroyWaiting, _inst);	
			return;
		}
		var _index = array_get_index(self.array, _inst);
		if (_index == -1) return;
		array_delete(self.array, _index, 1);
	}
	static clearDestroyed = function() {
		if (!destroyEnabled) return;	
		array_foreach(self.destroyWaiting, function(_inst) {
			var _index = array_get_index(self.array, _inst);
			if (_index == -1) return;
			array_delete(self.array, _index, 1);
			instance_destroy(_inst);
		});
	}
	static runSteps = function() {
		self.beginStep();
		self.step();
		self.endStep();
		self.clearDestroyed();
	}
	static beginStep = function() {
		array_foreach(self.array, function(_instance) {
			if (_instance.active) _instance.beginStep();
		});
	}
	static step = function() {
		array_foreach(self.array, function(_instance) {
			if (_instance.active) _instance.step();
			
		});
	}
	static endStep = function() {
		array_foreach(self.array, function(_instance) {
			if (_instance.active) _instance.endStep();
		});
	}
	static create = function(_x, _y, _object) {
		return self.createDepth(_x, _y, 0, _object);	
	}
	static initializeInstance = function(_inst) {
		_inst[$ "create"] ??= function() {};
		_inst[$ "beginStep"] ??= function() {};
		_inst[$ "step"] ??= function() {};
		_inst[$ "endStep"] ??= function() {};	
		_inst[$ "destroy"] ??= function() {};	
		_inst[$ "serialize"] ??= function() { return {} };	
		_inst[$ "deserialize"] ??= function() { return {} };	
		_inst[$ "active"] ??= true;
	}
	static createDepth = function(_x, _y, _depth, _object) {
		var _inst = instance_create_depth(_x, _y, _depth, _object);
		array_push(self.array, _inst);
		initializeInstance(_inst);
		return _inst;
	}
	static createLayer = function(_x, _y, _layer, _object) {
		var _inst = instance_create_layer(_x, _y, _layer, _object);
		array_push(self.array, _inst);
		initializeInstance(_inst);
		return _inst;
	}
}