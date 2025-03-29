function NET_Serializer() constructor {
	self.owner = other;
	self.variables = [];
	static addVariable = function(_variable) {
		array_push(self.variables, new NET_SerializerVariable(self.owner, _variable));
		return self;
	}
	static addCustom = function(_variable) {
		array_push(self.variables, new NET_SerializerCustom(self.owner, _variable));
		return self;
	}
	static addClone = function(_variable) {
		array_push(self.variables, new NET_SerializerClone(self.owner, _variable));
		return self;
	}
	static serialize = function() {
		array_foreach(self.variables, function(_variable) {
			_variable.setValue(_variable.serialize());
		});
	}
	static deserialize = function() {
		array_foreach(self.variables, function(_variable) {
			_variable.deserialize(_variable.getValue());
		});
	}
}