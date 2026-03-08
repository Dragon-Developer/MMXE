function XCharacter() : BaseCharacter() constructor{
	
	self.weapons = [xBuster, FireWave, ElectricWeb, ShotgunIce, WaveBurner];
	
	self.possible_armors = [
		[noone, XFirstArmorHead, XSecondArmorHead],//heads
		[noone, XFirstArmorArms, XSecondArmorArms, XHermesArmorArms],//arms
		[noone, XFirstArmorBody, XSecondArmorBody],//bodies
		[noone, XFirstArmorBoot, XSecondArmorBoot, XBladeArmorBoot],//boots
		[noone]//no full sets yet but ult armor would be good here
	];
	self.init = function(_player){
		
		self.init_default(_player);
		add_dash(_player);
		add_wall_jump(_player);
	}
}