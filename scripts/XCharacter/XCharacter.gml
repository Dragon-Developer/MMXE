function XCharacter() : BaseCharacter() constructor{
	
	self.weapons = [xBuster, SpinningWheel];
	
	self.possible_armors = [
		[noone, XFirstArmorHead, XSecondArmorHead],//heads
		[noone, XFirstArmorArms, XSecondArmorArms],//arms
		[noone, XFirstArmorBody, XSecondArmorBody],//bodies
		[noone, XFirstArmorBoot, XSecondArmorBoot, XBladeArmorBoot],//boots
		[noone]//no full sets yet but ult armor would be good here
	];
	self.init = function(_player){
		
		self.init_default(_player);
		with(_player){
			add_dash();
			add_wall_jump();
		}
	}
}