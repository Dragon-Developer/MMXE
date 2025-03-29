function NET_GameLockstep() : NET_GameBase() constructor {
	self.__ping_manager = new PingManager();
	self.__last_input_frame = -1;
	self.__input_delay = 10;
	self.__running = false;
	static on_ping_received = function(_ping) {
		self.__ping_manager.on_ping_received(_ping);
		self.__input_delay = self.__ping_manager.calculate_dynamic_delay();
	}
	static add_local_input = function() {
		if (self.__last_input_frame - self.__current_frame >= self.__input_delay) return;
		self.__last_input_frame++;
		var _inputs = self.add_local_inputs(self.__last_input_frame);
		var _frame = self.__last_input_frame;
		self.trigger_event("input_local", {
			inputs: _inputs,
			frame: _frame
		});
	}
	static start = function() {
		NET_GameWrapper.add(self);
		self.__started = true;
		self.add_local_input();
	}
	static step = function() {
		if (!self.__started) return;
		self.__running = (self.__running && self.inputs.canContinue(self.__current_frame))
					|| (self.inputs.canContinue(self.__last_input_frame));
		if (self.__running) {
			self.run_current_frame();
			self.inputs.removeFrame(self.__current_frame++);
		}
		self.add_local_input();
	}
}
