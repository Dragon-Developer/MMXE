function ProjectileWeapon() : WeaponData() constructor{
	self.projectiles = noone;//hmmm
	self.charge_time = 60;//i dont think mmxe uses this, but battle network has some busters charge faster than others
	self.animation_name = noone;//if its noone, then assume its _shoot. 
}

function ProjectileData() constructor{
	/*
		projectileData is the data that a projectile uses to function.
		this also includes stuff like damage and comboiness
	*/
	self.damage = 1;
	self.comboiness = 1;//i doubt this will last. its meant to be like zxa because i saw something about
	// model a having no comboiness on the buster shots. 
	
	self.create = function(){/*do startup things here*/}
	self.step = function(){/*do movement things here*/}
	self.draw = function(){/*do animator things here*/}
}