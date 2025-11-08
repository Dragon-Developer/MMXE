#macro NET_ROLLBACK_DEBUG true
function NET_GameRollback() : NET_GameBase() constructor {
	enum NET_ROLLBACK_MODE {
		NORMAL,
		PREDICTING,
		ROLLBACK,
		LOCKED
	}
	self.identifier = "rollback";
	self.__last_input_frame = -1;
	self.__input_delay = 1;
	self.__max_predicted_frames = 5;
	self.__saved_state = undefined;
	self.__last_confirmed_frame = -1;
	self.__mode = NET_ROLLBACK_MODE.NORMAL;
	self.__waiting_frames = 2;
	self.__ping_manager = new NET_PingManager();
	self.__ping_manager.set_offset(4);

	self.on_ping_received = function(_ping) {
		self.__ping_manager.on_ping_received(_ping);
		self.__max_predicted_frames = self.__ping_manager.calculate_dynamic_delay();
	}

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

	self.save_state = function() {
		self.__last_confirmed_frame = self.__current_frame;
		if (NET_ROLLBACK_DEBUG) LOG.print("[ROLLBACK] Saving state at frame: " + string(self.__current_frame));
		self.game_loop.save_state();
	}

	self.load_state = function() {
		var _confirmed = self.__last_confirmed_frame;
		if (NET_ROLLBACK_DEBUG) LOG.print("[ROLLBACK] Loading state from confirmed frame: " + string(_confirmed));
		self.game_loop.load_state();
	};

	self.roll_forward = function() {
		var _target_frame = self.__current_frame;
		self.load_state();
		self.__current_frame = self.__last_confirmed_frame;
		self.__mode = NET_ROLLBACK_MODE.NORMAL;

		if (NET_ROLLBACK_DEBUG) LOG.print("[ROLLBACK] Roll forward from " + string(self.__current_frame) + " to " + string(_target_frame));
	
		while (self.__current_frame < _target_frame) {
			if (self.__mode == NET_ROLLBACK_MODE.NORMAL && !self.inputs.canContinue(self.__current_frame)) {
				self.__mode = NET_ROLLBACK_MODE.PREDICTING;
			}
			self.advance_frame();
		}

		if (NET_ROLLBACK_DEBUG) LOG.print("[ROLLBACK] Roll forward complete. Current frame: " + string(self.__current_frame) + ", mode: " + self.mode_to_string(self.__mode));
	};

	self.add_input = function(_frame, _player_index, _input) {
		var _last_input = self.inputs.getLastInput(_player_index);

		if (!is_undefined(_last_input) && self.__current_frame > _frame && !self.inputs.isInputEqual(_last_input, _input)) {
			self.__mode = NET_ROLLBACK_MODE.ROLLBACK;
		}

		var _added = self.inputs.addInput(_frame, _player_index, _input);

		if (self.__mode == NET_ROLLBACK_MODE.LOCKED && self.inputs.canContinue(self.__last_confirmed_frame + 1)) {
			if (NET_ROLLBACK_DEBUG) LOG.print("[ROLLBACK] Input confirmed, leaving LOCKED.");
			self.__mode = NET_ROLLBACK_MODE.ROLLBACK;
		}

		return _added;
	};

	self.mode_to_string = function(mode) {
		switch (mode) {
			case NET_ROLLBACK_MODE.NORMAL: return "NORMAL";
			case NET_ROLLBACK_MODE.PREDICTING: return "PREDICTING";
			case NET_ROLLBACK_MODE.ROLLBACK: return "ROLLBACK";
			case NET_ROLLBACK_MODE.LOCKED: return "LOCKED";
		}
	}
	self.debug_rollback_state = function(_label = "", _input_window = 0) {
		var _log = "[NET DEBUG]";
		if (_label != "") _log += " [" + _label + "]";
		_log += "\n";

		_log += "  current_frame: " + string(self.__current_frame) + "\n";
		_log += "  last_input_frame: " + string(self.__last_input_frame) + "\n";
		_log += "  last_confirmed_frame: " + string(self.__last_confirmed_frame) + "\n";
		_log += "  mode: " + self.mode_to_string(self.__mode) + "\n";
		_log += "  waiting_frames: " + string(self.__waiting_frames) + "\n";
		_log += "  canContinue: " + string(self.inputs.canContinue(self.__current_frame)) + "\n";
		_log += "  predicted_frames: " + string(self.__current_frame - self.__last_confirmed_frame) + "\n";


		var _players = array_length(self.__local_players);
		var _start_frame = max(0, self.__current_frame - _input_window);
		var _end_frame = self.__current_frame;

		for (var f = _start_frame; f <= _end_frame; f++) {
			_log += "  Frame " + string(f) + ": ";
			for (var p = 0; p < _players; p++) {
				var inp = self.inputs.getInput(f, p);
				_log += "P" + string(p) + "=" + string(inp) + " ";
			}
			_log += "\n";
		}
		
		log(_log);

		if (NET_ROLLBACK_DEBUG) log(_log);
	}

	self.start = function() {
		NET_GameWrapper.add(self);
		self.__started = true;
		self.add_local_input();
	};

	self.advance_frame = function() {
		if (self.__mode == NET_ROLLBACK_MODE.NORMAL && self.inputs.canContinue(self.__current_frame)) {
			self.inputs.deleteFramesUntil(self.__last_confirmed_frame - 2);
			self.save_state();
		}
		if (NET_ROLLBACK_DEBUG) LOG.print("- Run frame: " + string(self.__current_frame));
		if (NET_ROLLBACK_DEBUG) self.game_loop.print("Inputs: " + json_stringify(self.inputs.getFormattedInputs(self.__current_frame)));
		self.run_current_frame();
		self.__current_frame++;
	};

	self.__debug_keys = function() {
		if (keyboard_check_pressed(vk_f1)) {
			self.debug_rollback_state("DEBUG F1", 10);
			log("F1")
		}
		if (keyboard_check_pressed(vk_f2)) {
			if (NET_ROLLBACK_DEBUG) log("canContinue(" + string(self.__current_frame) + "): " + string(self.inputs.canContinue(self.__current_frame)));
		}
	};

	self.step = function() {
		if (!self.__started) return;

		if (self.__waiting_frames > 0) {
			self.__waiting_frames--;
			if (self.__waiting_frames == 0) {
			self.add_local_input();
				self.save_state();
			}
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
			self.__mode = NET_ROLLBACK_MODE.PREDICTING;	
		}

		if (self.__mode == NET_ROLLBACK_MODE.PREDICTING && (self.__current_frame - self.__last_confirmed_frame) > self.__max_predicted_frames) {
			if (NET_ROLLBACK_DEBUG) LOG.print("[ROLLBACK] Exceeded prediction limit. Locked game.");
			self.__mode = NET_ROLLBACK_MODE.LOCKED;
		}

		if (self.__mode != NET_ROLLBACK_MODE.LOCKED) {
			self.add_local_input();
			self.advance_frame();
		}
		self.__debug_keys();
	};

	self.on_normal = function() { return self.__mode == NET_ROLLBACK_MODE.NORMAL && self.inputs.canContinue(self.__current_frame); }
}
