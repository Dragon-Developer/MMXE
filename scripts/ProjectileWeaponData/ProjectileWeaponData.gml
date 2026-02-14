function ProjectileWeapon() : Weapon() constructor{
	self.term = "Projectile";
}

function ProjectileData() constructor{
	/*
		projectileData is the data that a projectile uses to function.
		this also includes stuff like damage and comboiness
	*/
	self.term = "Projectile";
	self.dir = 1;
	self.damage = 1;
	self.shot_limit = 1;
	self.comboiness = 1;//gonna follow z3's system
	self.init_time = CURRENT_FRAME;
	self.animation = "xShot1";
	self.animation_append = "_shoot";
	self.hitbox_scale = new Vec2(8,8);
	self.hitbox_offset = new Vec2(0,0);
	self.tag = ["enemy"]
	self.piercing = false;
	self.general_init = function(_comp){
		self.dir = _comp.get_instance().components.get(ComponentAnimation).animation.__xscale;
	}
	self.draw = function(){
		//add your shit here
	}
	self.destroy = function(){
		
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