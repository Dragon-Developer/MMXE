function EntityComponentInstance() : EntityComponentBase() constructor {
	self.on_register = function() {
		self.serializer.setOwner(parent.get_instance());
	}
	self.serializer
		.addVariable("x")
		.addVariable("y")
		.addVariable("image_xscale")
		.addVariable("image_yscale")
}