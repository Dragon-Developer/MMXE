function MultiTap() constructor {
	self.currentKey = undefined;
	self.minInterval = 15; 
	self.timer = 0;
	self.enabled = false;
	self.tapCount = 0;
	self.serializer = new NET_Serializer();
	self.serializer
		.addVariable("currentKey")
		.addVariable("minInterval")
		.addVariable("timer")
		.addVariable("enabled")
		.addVariable("tapCount")
	
	self.onPressed = function(_key, _count) {}
	static pressed = function(_key) {
		if (!is_undefined(self.currentKey) && self.currentKey != _key) {
			self.reset();
			self.currentKey = _key;
		}
		self.enabled = true;
		self.tapCount++;
		self.onPressed(_key, self.tapCount);
		self.timer = 0;	
	}
	static reset = function() {
		self.timer = 0;
		self.enabled = false;
		self.currentKey = undefined;
		self.tapCount = 0;
	}
	static step = function() {
		if (!self.enabled) return;
		self.timer++;
		if (self.timer >= self.minInterval) {
			self.reset();
		}
	}
}