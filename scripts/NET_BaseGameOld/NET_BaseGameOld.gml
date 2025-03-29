function NET_BaseGameOld() constructor {
	self.instances = new NET_InstanceManager();
	self.inputs = new NET_InputManager();
	self.currentFrame = 0;
	self.started = false;
	self.playerIndex = 0;
	static setTotalPlayers = function(_total_players) {
		self.inputs.setTotalPlayers(_total_players);
	}
	static getTotalPlayers = function() {
		return self.inputs.getTotalPlayers();	
	}
	static resetLocalInput = function() {
		
	}
	static getLocalInput = function() {
		return {
			left: keyboard_check(vk_left),
			right: keyboard_check(vk_right),
			up: keyboard_check(vk_up),
			down: keyboard_check(vk_down),
			attack: keyboard_check(ord("Z"))
		};
	}
	static addLocalInput = function() {
		var _input = self.getLocalInput();
		self.inputs.addInput(self.currentFrame, self.playerIndex, _input);
	}
	static getInput = function(_player_index) {
		return self.inputs.getInput(self.currentFrame, _player_index);	
	}
	static addInput = function(_frame, _player_index, _input) {
		return self.inputs.addInput(_frame, _player_index, _input);
	}
	static start = function() {
		self.started = true;
	}
	static runCurrentFrame = function() {
		self.instances.beginStep();
		self.instances.step();
		self.instances.endStep();
	}
	static step = function() {
		if (!started) return;
		self.addLocalInput();
		self.runCurrentFrame();
		self.inputs.removeFrame(self.currentFrame++);
	}
}