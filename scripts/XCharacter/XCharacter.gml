function XCharacter() : BaseCharacter() constructor{
	self.weapons = [xBuster, FireWave, ElectricWeb, ShotgunIce, WaveBurner, RollingShield];
	
	self.possible_armors = [
		[noone, XFirstArmorHead, XSecondArmorHead, XGaeaArmorHead],//heads
		[noone, XFirstArmorArms, XSecondArmorArms, XGaeaArmorArms, XHermesArmorArms],//arms
		[noone, XFirstArmorBody, XSecondArmorBody, XGaeaArmorBody],//bodies
		[noone, XFirstArmorBoot, XSecondArmorBoot, XGaeaArmorBoot, XBladeArmorBoot],//boots
		[noone, ArmorDoubleGear]//no full sets yet but ult armor would be good here
	];
	self.init = function(_player){
		
		self.init_default(_player);
		add_dash(_player);
		add_wall_jump(_player);
	}
}