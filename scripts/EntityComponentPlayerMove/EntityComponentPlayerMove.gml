function EntityComponentPlayerMove() : EntityComponentBase() constructor {
	self.on_register = function() {
		self.input = self.parent.find("input") ?? new EntityComponentInputBase();
		PlayerSnowStateSetup();
	}
	self.step = function() {
		/*self.hdir = self.input.get_input("right") - self.input.get_input("left");
		if (self.hdir != 0) self.publish("animation_xscale", self.hdir);
		if (self.hdir != 0) {
			self.publish("animation_play", { name: "walk" });
		} else {
			self.publish("animation_play", { name: "idle" });
		}
		var _inst = parent.get_instance();
		_inst.x += self.hdir * 1.5;*/
		self.fsm.step();
		self.fsm.check();//seperate state events and checks. cleaner code?
	}
}