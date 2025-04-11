function EntityManager() constructor {
	self.__instances = [];
	self.__instance_map = {};
	self.__next_id = 0;
	self.__component_map = {};
	/**
	 * Caches the given component to be reused later.
	 * Ensures the component is stored in the corresponding constructor-based map.
	 * @param {Struct.EntityComponent} component - The component instance to cache.
	 */
	static cache_component = function(_component) {
		var _constructor = _component.get_constructor();
		self.__component_map[$ _constructor] ??= [];
		var _array = self.__component_map[$ _constructor];
		var _index = array_get_index(_array, _component);
		if (_index != -1) return;
		array_push(_array, _component);	
	}
	/**
	 * Removes the given component from the cache.
	 * Ensures the component is deleted from the corresponding constructor-based map.
	 * @param {Struct.EntityComponent} component - The component instance to remove.
	 */
	static remove_component = function(_component) {
		var _constructor = _component.get_constructor();
		self.__component_map[$ _constructor] ??= [];
		var _array = self.__component_map[$ _constructor];
		var _index = array_get_index(_array, _component);
		if (_index == -1) return;
		array_delete(_array, _index, 1);
	}

	/**
	 * Creates a new instance and returns it.
	 * @param {Asset.GMObject} _object - The object containing components.
	 * @returns {Instance} The created instance.
	 */
	static create_instance = function(_object) {
		var _inst = instance_create_depth(0, 0, 0, _object);
		_inst.components.__id = self.__next_id++;

		array_push(self.__instances, _inst);
		self.__instance_map[$ _inst.components.__id] = _inst;

		self.publish("entity_created", _inst);

		return _inst;
	};

	/**
	 * Destroys an instance and removes it from the manager.
	 * @param {Instance} _inst - The instance to be destroyed.
	 */
	static destroy_instance = function(_inst) {
		var _index = array_get_index(self.__instances, _inst);
		if (_index == -1) return false;

		var _id = _inst.components.__id;
		
		_inst.components.publish("entity_destroyed", _inst);
		remove_all_components(_inst);
		instance_destroy(_inst);
		array_delete(self.__instances, _index, 1);
		struct_remove(self.__instance_map, _id);

		return true;
	};

	/**
	 * Removes all components from an entity.
	 * @param {Instance} _inst - The instance from which to remove all components.
	 */
	static remove_all_components = function(_inst) {
		// Iterate over all components of the entity
		array_foreach(_inst.components.__components, method({ this: other, inst: _inst }, function(_component) {
			if (!instance_exists(inst)) return;
		    this.remove_component(_component);
		}));
		_inst.components.__components = [];
	};

	/**
	 * Returns an array of components of a given type.
	 * @param {function} _component_type - The component type to search for.
	 * @returns {Array<Component>} An array of matching components.
	 */
	static get_ecs_components = function(_component_type) {
		if (struct_exists(self.__component_map, _component_type)) {
			return self.__component_map[$ _component_type];
		}
		return [];
	};
	
	/**
	 * Executes a function for each component of a given type.
	 * @param {function} _component_type - The component type.
	 * @param {function} _callback - The function to execute on each component.
	 */
	static for_each_component = function(_component_type, _callback) {
		array_foreach(self.get_ecs_components(_component_type), _callback);
	};

	/**
	 * Returns the instance by ID.
	 * @param {number} _id - The entity ID.
	 * @returns {Instance|undefined} The found instance, or undefined if not found.
	 */
	static find_by_id = function(_id) {
		return self.__instance_map[$ _id];
	};

    /**
     * Returns the first instance that has the specified tags.
     * @param {Array<string>} _tags - The tags to search for.
     * @returns {Instance|undefined} The found instance, or undefined if none match.
     */
	static find = function(_tags) {
		for (var i = 0; i < array_length(self.__instances); i++) {
			var _inst = self.__instances[i];
			if (asset_has_tags(_inst.object_index, _tags, asset_object)) {
				return _inst;
			}
		}
		return undefined;
	};


    /**
     * Returns all instances that have the specified tags.
     * @param {Array<string>} _tags - The tags to search for.
     * @returns {Array<Instance>} An array of matching instances.
	 */
	static find_all = function(_tags) {
		var _results = [];
		for (var i = 0; i < array_length(self.__instances); i++) {
			var _inst = self.__instances[i];
			if (asset_has_tags(_inst.object_index, _tags, asset_object)) {
				array_push(_results, _inst);
			}
		}
		return _results;
	};


    /**
     * Publishes an event to all instances.
     * @param {string} _event - The event name.
     * @param {any} _args - The event arguments.
     */
	static publish = function(_event, _args) {
		array_foreach(self.__instances, method({ event: _event, args: _args }, function(_inst) {
			if (!instance_exists(_inst)) return;
				_inst.components.publish(event, args);
			})
		);
	};

    /**
     * Subscribes a callback to an event for all instances.
     * @param {string} _event - The event name.
     * @param {function} _callback - The callback function.
     */
	static subscribe = function(_event, _callback) {
		array_foreach(self.__instances, method({ event: _event, args: _args }, function(_inst) {
		if (!instance_exists(_inst)) return;
			_inst.components.subscribe(event, callback);
		}));
	};
	
	static find_by_tags = function(_tags = []) {
		var _array = [];
		with (obj_entity) {
			if (!asset_has_tags(object_index, _tags, asset_object)) continue;
			array_push(_array, id);
		}
		return _array;
	}
	
	static pause = function(_tags, _value) {
		var _instances = self.find_by_tags(_tags);
		array_foreach(_instances, method({ value: _value }, function(_inst) {
			_inst.components.pause(value);
		}));
	}
	static save = function() {
		array_foreach(self.__instances, function(_inst) {
			_inst.components.save();
		});
	}
	static load = function() {
		array_foreach(self.__instances, function(_inst) {
			_inst.components.load();
		});
	}
}