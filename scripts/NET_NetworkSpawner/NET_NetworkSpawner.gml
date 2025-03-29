function NET_NetworkSpawner() constructor {
	self.objectStruct = {};
	self.entityManager = new NET_EntityManager();
	static addObject = function(_name) {
		objectStruct[$ _name] = asset_get_index(_name);
		return self;
	}
	static getObject = function(_name) {
		return objectStruct[$ _name];	
	}
	static createInstance = function(_object) {
		var _inst = instance_create_depth(0, 0, 0, _object);
		_inst.net.isLocal = true;
		var _id = self.entityManager.generateID();
		_inst.net.id = _id;
		self.set(_id, _inst);
		return _inst;
	}
	static getOrCreate = function(_id, _object) {
		var _inst = self.get(_id);
		if (_inst != noone) {
			return _inst;	
		}
		_inst = instance_create_depth(0, 0, 0, getObject(_object));
		_inst.net.id = _id;
		self.set(_id, _inst);
		return _inst;
	}
	static set = function(_id, _inst) {
		return self.entityManager.set(_id, _inst);
	}
	static get = function(_id) {
		return self.entityManager.get(_id);
	}
	static has = function(_id) {
		return self.entityManager.has(_id);
	}
	static remove = function(_id) {
		self.entityManager.remove(_id);
	}
	static update = function(_id, _data) {
		return self.entityManager.update(_id, _data, function(_instance, _data) {
			_instance.net.applyUpdate(_data);
		});
	}
}