function ProjectileWeapon() : Weapon() constructor{
	self.data = [noone,noone,noone,noone, noone];//hmmm
	//self.charge_time = [30, 105, 180, 255];//i dont think mmxe uses this, but battle network has some busters charge faster than others
	self.charge_limit = 2;
	self.animation_name = noone;//if its noone, then assume its _shoot.
	self.weapon_palette = [
		#203080,//Blue Armor Bits
		#0040f0,
		#0080f8,
		#1858b0,//Under Armor Teal Bits
		#50a0f0,
		#78d8f0,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
}

function ProjectileData() constructor{
	/*
		projectileData is the data that a projectile uses to function.
		this also includes stuff like damage and comboiness
	*/
	self.dir = 1;
	self.damage = 1;
	self.comboiness = 1;//gonna follow z3's system
	self.init_time = CURRENT_FRAME;
	self.general_init = function(_comp){
		self.dir = _comp.get_instance().components.get(ComponentAnimation).animation.__xscale;
	}
	self.draw = function(){
		//add your shit here
	}
}

/*

The basic idea with the weapon/data split is as follows
	- the data holds things that can/will change as the projectile moves. this includes
		things like instance variables, direction, damage, etc
	- the weapon holds things that are immutable. this includes base charge time, animation,
		the associated data, weaponbar cosmetics, and max energy. 
	- if it's something that the projectile needs, put it in the data. if its something
		the player needs to make the projectile work, put it in the weapon.

*/