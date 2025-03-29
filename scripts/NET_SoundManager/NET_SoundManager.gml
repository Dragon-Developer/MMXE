function SoundManager() constructor {
	self.nextID = 0;
	self.playingSounds = {};
	self.currentFrame = 0;
	self.frameSounds = {};
	static setCurrentFrame = function(_frame) {
		self.currentFrame = _frame;
	}
	static generateID = function() {
		return self.nextID++;	
	}
	static play = function(_sound, _priority, _loop) {
		var _index = self.generateID();
		var _existing_sound = self.frameSounds[$ self.currentFrame].hasSound(_sound);
		if (!is_undefined(_existing_sound)) {
			struct_remove(self.playingSounds, _existing_sound.index);
			_existing_sound.index = _index;
			
		}
		self.playingSounds[$ _index] = new SoundInstance(_sound, _priority, _loop, _index);
		return _index;
	}
	static pause = function(_index) {
		
	}
	static resume = function(_index) {
		
	}
	static stop = function() {
		
	}
	static pauseAll = function() {
		
	}
	static resumeAll = function() {
		
	}
}
function SoundFrame() constructor {
	self.sounds = {};
	static findSound = function(_sound_asset) {
		var _names = variable_struct_get_names(self.sounds);
		for (var _i = 0, _len = array_length(_names); _i < _len; _i++) {
			var _name = _names[_i];
			if (self.sounds[$ _name].asset == _sound_asset) {
				return self.sounds[_name];
			}
		}
		return undefined;
	}
}
function SoundInstance() constructor {
	self.asset = -1;
	self.index = 0;
}