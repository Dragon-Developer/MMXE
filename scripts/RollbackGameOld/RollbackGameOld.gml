function RollbackGame() : NET_BaseGameOld() constructor {
	enum ROLLBACK_MODE {
		NORMAL,
		PREDICTING,
		ROLLBACK,
		LOCKED,
	};
	self.lastInputFrame = -1;
	self.inputDelay = 3;
	self.maxPredictedFrames = 15;
	self.sendInput = function(_frame, _input) {};
	self.savedState = undefined;
	self.lastConfirmedFrame = -1;
	self.mode = ROLLBACK_MODE.LOCKED;
	self.waitingFrames = 0;
	self.currentInput = {};
	self.inputs.setKeys(["left", "right", "up", "down", "attack"]);
	static saveState = function() {
		self.lastConfirmedFrame = self.currentFrame;
		self.instances.saveAllInstances();
	}
	static loadState = function() {
		self.instances.restoreAllInstances();
	}
	static getInput = function(_player_index) {
		if (self.inputs.hasInput(self.currentFrame, _player_index))
			return self.inputs.getInput(self.currentFrame, _player_index);	
		return self.inputs.getLastInput(_player_index);
	}
	static rollForward = function() {
		var _desired_frame = self.currentFrame;	
		self.currentFrame = self.lastConfirmedFrame;
		self.mode = ROLLBACK_MODE.NORMAL;	
		while (self.currentFrame < _desired_frame) {
			if (self.mode == ROLLBACK_MODE.NORMAL && !self.inputs.canContinue(self.currentFrame)) {
				self.saveState();
				self.mode = ROLLBACK_MODE.PREDICTING;	
			}
			self.advanceFrame();
		}
	}
	static addInput = function(_frame, _player_index, _input) {
		var _last_input = self.inputs.getLastInput(_player_index);
		if (!is_undefined(_last_input) && self.currentFrame > _frame && !self.inputs.isInputEqual(_last_input, _input)) {
			self.mode = ROLLBACK_MODE.ROLLBACK;
		}
		return self.inputs.addInput(_frame, _player_index, _input);
	}
	static addLocalInput = function() {
		self.currentInput = self.inputs.inputJoin(self.currentInput, self.getLocalInput());
		if (self.lastInputFrame - self.currentFrame >= self.inputDelay) return;
		var _input = self.currentInput;
		self.lastInputFrame++;
		self.inputs.addInput(self.lastInputFrame, self.playerIndex, _input);
		self.sendInput(self.lastInputFrame, _input);
		self.currentInput = self.inputs.getEmptyInput();
	}
	static start = function() {
		self.started = true;
		self.saveState();
		self.currentInput = self.getLocalInput();
		self.addLocalInput();
	}
	static advanceFrame = function() {
		if (self.mode == ROLLBACK_MODE.NORMAL) {
			self.inputs.deleteFramesUntil(self.currentFrame - 2);
		}
		self.runCurrentFrame();
		self.currentFrame++;
	}
	static step = function() {
		if (!self.started) return;
		if (self.waitingFrames > 0) {
			self.waitingFrames--;
			self.currentInput = self.inputs.inputJoin(self.currentInput, self.getLocalInput());
			return;
		}
		if (self.mode == ROLLBACK_MODE.ROLLBACK) {
			self.loadState();
			self.rollForward();
		}
		if (self.inputs.canContinue(self.currentFrame)) {
			self.mode = ROLLBACK_MODE.NORMAL;	
		}
		if (self.mode == ROLLBACK_MODE.NORMAL && !self.inputs.canContinue(self.currentFrame)) {
			self.saveState();
			self.mode = ROLLBACK_MODE.PREDICTING;	
		}
		if (self.mode == ROLLBACK_MODE.PREDICTING && (self.currentFrame - self.lastConfirmedFrame) > self.maxPredictedFrames) {
			self.waitingFrames++;
		}
		if (self.mode != ROLLBACK_MODE.LOCKED) {
			self.advanceFrame();
		}
		self.addLocalInput();
	}
}