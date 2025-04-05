function EntityComponentInstance() : EntityComponentBase() constructor {
	self.init = function() {
		self.serializer.setOwner(parent.get_instance());
		self.serializer
			.addVariable("x")
			.addVariable("y")
			.addVariable("image_xscale")
			.addVariable("image_yscale")
	}
	self.x = 0;
	self.y = 0;
	self.save = function() {
		var _inst = parent.get_instance();
		/*
		self.serializer.setOwner(_inst);
		self.serializer.serialize();*/
		x = _inst.x;
		y = _inst.y;
	}
	self.load = function() {
		var _inst = parent.get_instance();
		_inst.x = x;
		_inst.y = y;
//		self.serializer.deserialize();	
	}
}