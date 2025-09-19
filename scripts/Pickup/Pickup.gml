function Pickup() constructor{
	self.pause_on_pickup = false;
	self.rate = 2;
	self.apply = function(_damageable){
		_damageable.heal(self.rate, self.pause);
	}
}