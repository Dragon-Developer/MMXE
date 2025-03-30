function Vec2(_x = 0, _y = 0) constructor {
	self.x = _x;
	self.y = _y;
	static add = function(_v) {
		return new Vec2(self.x + _v.x, self.y + _v.y);
	}
	static subtract = function(_v) {
		return new Vec2(self.x - _v.x, self.y - _v.y);
	}
	static multiply = function(_k) {
		return new Vec2(self.x * _k, self.y * _k);	
	}
	static divide = function(_k) {
		return new Vec2(self.x / _k, self.y / _k);	
	}
	static dot = function(_v) {
		return self.x * _v.x + self.y * _v.y;
	}
	static length = function() {
		return point_distance(0, 0, self.x, self.y);	
	}
	static normalize = function() {
		return self.divide(self.length());
	}
	static angle = function() {
		return point_direction(0, 0, self.x, self.y);
	}
	static create = function(_v) {
		return new Vec2(_v.x, _v.y);	
	}
	static scale = function(_v) {
		return new Vec2(self.x * _v.x, self.y * _v.y);	
	}
	static setX = function(_x) {
		self.x = _x;
		return self;
	}
	static setY = function(_y) {
		self.y = _y;
		return self;	
	}
	static set = function(_x, _y) {
		self.x = _x;
		self.y = _y;
		return self;
	}
	static rotate = function(_angle) {
        var _radians = degtorad(_angle); 
        var _cos = cos(_radians);
        var _sin = sin(_radians);

        var _x = self.x * _cos - self.y * _sin;
        var _y = self.x * _sin + self.y * _cos;

        return new Vec2(_x, _y);
    }
	static rotate90 = function(_clockwise = false) {
	    var _factor = _clockwise ? 1 : -1;
	    return new Vec2(self.y * _factor, -self.x * _factor);
	}
}
Vec2();