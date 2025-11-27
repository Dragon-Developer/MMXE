function MeleeWeapon() : Weapon() constructor{
	self.term = "Melee";
}

function MeleeData() constructor{
	self.term = "Melee"
	
	self.damage = 1;
	self.comboiness = 2;
	self.animation = "atk1";
	self.tag = ["enemy"];
	self.hitbox_scale = new Vec2(64,64);
	self.hitbox_offset = new Vec2(32,0);
}