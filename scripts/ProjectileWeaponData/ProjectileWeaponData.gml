function ProjectileWeapon() : WeaponData() constructor{
	self.projectiles = noone;//projetile data doesnt exist yet.
	self.charge_time = 60;//i dont think mmxe uses this, but battle network has some busters charge faster than others
	
}

function ProjectileData() constructor{
	/*
		projectileData is the data that a projectile uses to function.
		this also includes stuff like damage and comboiness
	*/
	self.damage = 1;
	self.comboiness = 1;//someone please rename this variable. this is a bad name.
	self.animator = noone;//presumably, the animator would be used to show the shot graphics.
	
	self.create = function(){/*do startup things here*/}
	self.step = function(){/*do movement things here*/}
	self.draw = function(){/*do animator things here*/}
}