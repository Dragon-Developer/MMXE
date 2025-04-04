function NET_GameRollback() : NET_GameBase() constructor {
	enum NET_ROLLBACK_MODE {
		NORMAL,
		PREDICTING,
		ROLLBACK,
		LOCKED,
	};
	self.__ping_manager = new PingManager();
	self.__last_input_frame = -1;
	self.__input_delay = 0;
	self.__running = false;
	self.__max_predicted_frames = 15;
	self.__last_confirmed_frame = -1;
	self.__mode = NET_ROLLBACK_MODE.LOCKED;
	self.__waiting_frames = 0;
	static on_ping_received = function(_ping) {}
	self.add_local_input = function() {
		if (self.__last_input_frame - self.__current_frame >= self.__input_delay) return;
		self.__last_input_frame++;
		var _inputs = self.add_local_inputs(self.__last_input_frame);
		var _frame = self.__last_input_frame;
		self.trigger_event("input_local", {
			inputs: _inputs,
			frame: _frame
		});
	}
	static save_state = function() {
		self.__last_confirmed_frame = self.__current_frame;
		self.game_loop.save_state();
	}
	static load_state = function() {
		self.game_loop.load_state();
	}
	static roll_forward = function() {
		var _desired_frame = self.__current_frame;	
		self.__current_frame = self.__last_confirmed_frame;
		self.__mode = NET_ROLLBACK_MODE.NORMAL;	
		while (self.__current_frame < _desired_frame) {
			if (self.__mode == NET_ROLLBACK_MODE.NORMAL && !self.inputs.canContinue(self.__current_frame)) {
				self.save_state();
				self.__mode = NET_ROLLBACK_MODE.PREDICTING;	
			}
			self.advance_frame();
		}
	}
	self.add_input = function(_frame, _player_index, _input) {
		var _last_input = self.inputs.getLastInput(_player_index);
		if (!is_undefined(_last_input) && self.__current_frame > _frame && !self.inputs.isInputEqual(_last_input, _input)) {
			self.__mode = NET_ROLLBACK_MODE.ROLLBACK;
		}
		return self.inputs.addInput(_frame, _player_index, _input);
	}
	/*
	static addLocalInput = function() {
		self.currentInput = self.inputs.inputJoin(self.currentInput, self.getLocalInput());
		if (self.lastInputFrame - self.currentFrame >= self.inputDelay) return;
		var _input = self.currentInput;
		self.lastInputFrame++;
		self.inputs.addInput(self.lastInputFrame, self.playerIndex, _input);
		self.sendInput(self.lastInputFrame, _input);
		self.currentInput = self.inputs.getEmptyInput();
	}*/
	self.start = function() {
		NET_GameWrapper.add(self);
		self.__started = true;
		self.save_state();
		self.add_local_input();
	}
	static advance_frame = function() {
		if (self.__mode == NET_ROLLBACK_MODE.NORMAL) {
			self.inputs.deleteFramesUntil(self.__current_frame - 2);
		}
		self.run_current_frame();
		self.__current_frame++;
	}
	self.step = function() {
		if (!self.__started) return;
		if (self.__waiting_frames > 0) {
			self.__waiting_frames--;
//			self.currentInput = self.inputs.inputJoin(self.currentInput, self.getLocalInput());
			return;
		}
		if (self.__mode == NET_ROLLBACK_MODE.ROLLBACK) {
			self.load_state();
			self.roll_forward();
		}
		if (self.inputs.canContinue(self.__current_frame)) {
			self.__mode = NET_ROLLBACK_MODE.NORMAL;	
		}
		if (self.__mode == NET_ROLLBACK_MODE.NORMAL && !self.inputs.canContinue(self.__current_frame)) {
			self.save_state();
			self.__mode = NET_ROLLBACK_MODE.PREDICTING;	
		}
		if (self.__mode == NET_ROLLBACK_MODE.PREDICTING && (self.__current_frame - self.__last_confirmed_frame) > self.__max_predicted_frames) {
			self.__waiting_frames++;
		}
		if (self.__mode != NET_ROLLBACK_MODE.LOCKED) {
			self.advance_frame();
		}
		self.add_local_input();
	}
}
