function Pickup() constructor{
	self.pause_on_pickup = false;
	self.count = 2;
	self.apply = function(_damageable){
		_damageable.heal(self.count, self.pause);
	}
}