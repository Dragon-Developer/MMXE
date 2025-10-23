function Pickup() constructor{
	self.pause_on_pickup = false;
	self.count = 2;
	self.pause = false;
	self.apply = function(_damageable){
		_damageable.heal(self.count, self.pause);
	}
	self.sprite = "life_1"
}