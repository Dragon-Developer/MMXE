function AimableWeapon() : Weapon() constructor{
	self.term = "Aimable";
	self.cost = 0;
}

function AimableData() constructor{
	/*
		projectileData is the data that a projectile uses to function.
		this also includes stuff like damage and comboiness
	*/
	self.term = "Aimable";
	self.dir = 1;
	self.damage = 1;
	self.shot_limit = 1;
	self.comboiness = 1;//gonna follow z3's system
	self.init_time = CURRENT_FRAME;
	self.animation = "xShot1";
	self.animation_append = "_shoot";
	self.hitbox_scale = new Vec2(8,8);
	self.hitbox_offset = new Vec2(0,0);
	
	self.angle = new Vec2(1,0)
	
	self.tag = ["enemy"]
	self.general_init = function(_comp){
		self.dir = _comp.get_instance().components.get(ComponentAnimation).animation.__xscale;
	}
	self.draw = function(){
		//add your shit here
	}
}