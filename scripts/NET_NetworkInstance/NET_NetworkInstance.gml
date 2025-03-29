function NET_NetworkInstance(_owner = other) constructor {
	self.owner = _owner;
	self.isLocal = false;
	self.onCreation = true;
	self.objectName = "";
	self.variables = {};
	self.id = -1;
	self.variableValues = {};
	self.changedVariables = [];
	static getObjectName = function() {
		if (self.objectName == "") {
			self.objectName = object_get_name(owner.object_index);	
		}
		return self.objectName;
	}
	static resetVariables = function() {
		self.variables = {};	
		return self;
	}
	static addVariable = function(_name) {
		addVariableSetter(_name);
		addVariableGetter(_name);
		return self;
	}
	static setVariable = function(_name, _value) {
		variables[$ _name].setValue(_value, _name);
	}
	static getVariable = function(_name) {
		return variables[$ _name].getValue(_name);
	}
	static addVariableSetter = function(_name, _method = undefined) {
		if (is_undefined(_method)) {
			_method = function(_value, _name) {
				variable_instance_set(owner, _name, _value);
			};
		}
		if (!struct_exists(variables, _name))
			variables[$ _name] = {};
		variables[$ _name].setValue = _method;
		return self;
	}
	static addVariableGetter = function(_name, _method = undefined) {
		if (is_undefined(_method)) {
			_method = function(_name) {
				return variable_instance_get(owner, _name);
			};
		}
		if (!struct_exists(variables, _name))
			variables[$ _name] = {};
		variables[$ _name].getValue = _method;
		return self;
	}
	static updateVariableValues = function() {
		self.changedVariables = [];
		if (struct_names_count(self.variableValues) == 0) {
			struct_foreach(variables, function(_name) {
				self.variableValues[$ _name] = self.getVariable(_name);
			});
			return false;
		}
		struct_foreach(variables, function(_name) {
			var _new_value = self.getVariable(_name);
			if (struct_exists(self.variableValues, _name)) {
				var _previous_value = self.variableValues[$ _name];
				if (_previous_value != _new_value) {
					array_push(self.changedVariables, _name);	
				}
			}
			self.variableValues[$ _name] = _new_value;
		});
		return true;
	}
	static create = function() {
		updateVariableValues();
		sendFullUpdate();	
	}
	static step = function() {
		if (isLocal) {
			updateVariableValues();
			sendFullUpdate();	
		}
	}
	static destroy = function() {
		if (isLocal) {
			global.client.rpc.sendNotification("instance_destroy", {
				instance: id
			});	
		}
	}
	static sendUpdate = function(_type = "instance_update") {
		if (isLocal) {
			global.client.rpc.sendNotification(_type, {
				state: getChangedVariables(),
				object: getObjectName()
			});	
		}
	}
	static sendFullUpdate = function(_type = "instance_full") {
		if (isLocal) {
			global.client.rpc.sendNotification(_type, {
				state: getAllVariables(),
				object: getObjectName(),
				instance: id
			});	
		}
	}
	static applyUpdate = function(_update) {
		struct_foreach(_update, function(_name, _value) {
			self.setVariable(_name, _value);
		});
	}
	static getChangedVariables = function() {
		var _result = {};
		array_foreach(changedVariables, method({ this: other, result: _result }, function(_name) {
			result[$ _name] = this.variableValues[$ _name];
		}));
		return _result;
	}
	static getAllVariables = function() {
		var _result = {};
		struct_foreach(variables, method({ this: other, result: _result }, function(_name, _value) {
			result[$ _name] = this.variableValues[$ _name];
		}));
		return _result;
	}
	self.addVariable("x");
	self.addVariable("y");
	self.addVariable("sprite_index");
	self.addVariable("image_index");
	self.addVariable("image_xscale");
	self.addVariable("image_yscale");
	self.addVariable("depth");
}