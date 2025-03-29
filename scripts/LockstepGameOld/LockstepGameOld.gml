function LockstepGameold() : NET_GameBase() constructor {
	self.lastInputFrame = -1;
	self.maxInputDelay = 1;
	self.sendInput = function(_frame, _input) {};
	self.running = false;
	static addLocalInput = function() {
		if (self.lastInputFrame - self.currentFrame >= self.maxInputDelay) return;
		var _input = self.getLocalInput();
		self.lastInputFrame++;
		self.inputs.addInput(self.lastInputFrame, self.playerIndex, _input);
		self.sendInput(self.lastInputFrame, _input);
	}
	static start = function() {
		self.started = true;
		self.addLocalInput();
	}
	static step = function() {
		if (!started) return;
		self.running = (self.running && self.inputs.canContinue(self.currentFrame))
					|| (self.inputs.canContinue(self.lastInputFrame));
		if (self.running) {
			self.runCurrentFrame();
			self.inputs.removeFrame(self.currentFrame++);
		}
		self.addLocalInput();
	}
}
