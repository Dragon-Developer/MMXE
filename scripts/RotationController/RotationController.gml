function RotationController() constructor {
	self.previous_angle = 0;
	self.next_angle = 0;
	self.current_angle = 0;
	self.rotation_range = 1;
	self.channel = -1;
	self.timer = 0;
	self.interval = 60;
	self.enabled = false;
	self.set_rotation = function(_previous, _next) {
		self.rotation_range = _next - _previous;
		self.next_angle = _next;
		self.previous_angle = _previous;
		self.current_angle = _previous;
		return self;
	}
	self.set_interval = function(_interval) {
		self.interval = _interval;	
		return self;
	}
	self.activate = function() {
		self.enabled = true;	
	}
	self.step = function() {
		if (self.channel == -1) return;
		if (!self.enabled) return;
		var _posx = self.timer / self.interval;
		self.timer++;
		if (_posx >= 1) _posx = 1;
		var _posy = animcurve_channel_evaluate(self.channel, _posx);
		self.current_angle = self.previous_angle + self.rotation_range * _posy;
		if (self.timer >= self.interval) {
			self.enabled = false;
			self.current_angle = (self.next_angle + 360) mod 360;
			self.timer = 0;
			self.on_end();
		}
	}
	self.set_channel = function(_channel) {
		self.channel = _channel;	
	}
	self.on_end = function() {}
	self.set_channel(animcurve_get_channel(anc_rotate, "curve"));
}