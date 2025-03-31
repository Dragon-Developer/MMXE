function EntityComponentWorld() : EntityComponentBase() constructor {
	self.flip_up = function() {
		var _flip = function(_component) { _component.flip_up() };
		ENTITIES.for_each_component(EntityComponentPhysics, _flip);
		ENTITIES.for_each_component(EntityComponentAnimation, _flip);
		ENTITIES.for_each_component(EntityComponentMask, _flip);
		self.reset_speed();
	}
	self.rotate_up = function(_angle) {
		var _rotate = method({angle: _angle}, function(_component) { _component.rotate_up(angle) });
		ENTITIES.for_each_component(EntityComponentPhysics, _rotate);
		ENTITIES.for_each_component(EntityComponentAnimation, _rotate);
		ENTITIES.for_each_component(EntityComponentMask, _rotate);
		self.reset_speed();
	}
	self.reset_speed = function() {
		var _reset = function(_component) { _component.set_speed(0, 0); };
		ENTITIES.for_each_component(EntityComponentPhysics, _reset);
	}
}