function FlamethrowerWeapon() : Weapon() constructor{
	self.term = "Flamethrower";
}

function FlamethrowerData() : ProjectileData() constructor{
	/*
		projectileData is the data that a projectile uses to function.
		this also includes stuff like damage and comboiness
	*/
	self.term = "Flamethrower";
	self.shot_delay = 5;
}