#macro GM_NETCODE_SERIALIZER_HASH_ENABLED true

function NET_SerializerVariable(_owner, _name) constructor {
	self.owner = _owner;
	self.value = undefined;
	self.hash = (GM_NETCODE_SERIALIZER_HASH_ENABLED ? variable_get_hash(_name) : _name);
	static serialize = function() {
		if (GM_NETCODE_SERIALIZER_HASH_ENABLED) {
			return struct_get_from_hash(self.owner, self.hash);
		}
		return variable_struct_get(self.owner, self.hash);
	}
	static deserialize = function(_data) {
		if (GM_NETCODE_SERIALIZER_HASH_ENABLED) {
			struct_set_from_hash(self.owner, self.hash, _data);
			return;
		}
		variable_struct_set(self.owner, self.hash, _data);
	}
	static setValue = function(_value) {
		self.value = _value;	
	}
	static getValue = function() {
		return self.value;	
	}
}
function NET_SerializerCustom(_owner, _name) : NET_SerializerVariable(_owner, _name) constructor {
	static serialize = function() {
		try{
		var _value;
		if (GM_NETCODE_SERIALIZER_HASH_ENABLED) {
			_value = struct_get_from_hash(self.owner, self.hash);
		} else {
			_value = variable_struct_get(self.owner, self.hash);
		}
		if(struct_exists(_value,"serializer"))
		return _value.serializer.serialize();
		log("failed to serialize " + string(self.owner.identifier) + "!")
		} catch(_exception) {
			log(_exception.message);
			//log(self.owner)
		}
	}
	static deserialize = function(_data) {
		//if(_data == -4) return;
		var _value;
		if (GM_NETCODE_SERIALIZER_HASH_ENABLED) {
			_value = struct_get_from_hash(self.owner, self.hash);
		} else {
			_value = variable_struct_get(self.owner, self.hash);
		}
		
		if(struct_exists(_value,"serializer"))
			_value.serializer.deserialize(_data);
	}
}

function NET_SerializerClone(_owner, _name) : NET_SerializerVariable(_owner, _name) constructor {
	static serialize = function() {
		var _value;
		if (GM_NETCODE_SERIALIZER_HASH_ENABLED) {
			_value = struct_get_from_hash(self.owner, self.hash);
		} else {
			_value = variable_struct_get(self.owner, self.hash);
		}
		return variable_clone(_value);
	}
}