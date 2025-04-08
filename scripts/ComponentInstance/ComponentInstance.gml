function ComponentInstance() : ComponentBase() constructor {
	self.X = 0;
	self.Y = 0;
	self.save = function() {
		var _inst = parent.get_instance();
		self.X = _inst.x;
		self.Y = _inst.y;
	}
	self.load = function() {
		var _inst = parent.get_instance();
		_inst.x = self.X;
		_inst.y = self.Y;
	}
}