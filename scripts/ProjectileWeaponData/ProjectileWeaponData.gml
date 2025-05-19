function ProjectileWeapon() : Weapon() constructor{
	self.data = noone;//hmmm
	self.charge_time = 60;//i dont think mmxe uses this, but battle network has some busters charge faster than others
	self.animation_name = noone;//if its noone, then assume its _shoot. 
}

function ProjectileData() constructor{
	/*
		projectileData is the data that a projectile uses to function.
		this also includes stuff like damage and comboiness
	*/
	self.dir = 1;
	self.damage = 1;
	self.comboiness = 1;
}