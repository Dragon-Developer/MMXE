function XCharacter() : BaseCharacter() constructor{
	self.weapons = [xBuster, XSaber, FireWave, ElectricWeb, ShotgunIce, WaveBurner, RollingShield, TwinSlasher, MetalAnchor, GroundHunter];
	
	self.possible_armors = [
		[noone, XFirstArmorHead, XSecondArmorHead, XThirdArmorHead, XGaeaArmorHead],//heads
		[noone, XFirstArmorArms, XSecondArmorArms, XThirdArmorArms, XGaeaArmorArms, XHermesArmorArms],//arms
		[noone, XFirstArmorBody, XSecondArmorBody, XThirdArmorBody, XGaeaArmorBody],//bodies
		[noone, XFirstArmorBoot, XSecondArmorBoot, XThirdArmorBoot, XGaeaArmorBoot, XBladeArmorBoot, XFalconArmorBoot, XSillyArmors],//boots
		[noone, ArmorDoubleGear]//no full sets yet but ult armor would be good here
	];
	self.init = function(_player){
		
		self.init_default(_player);
		add_dash(_player);
		add_wall_jump(_player);
	}
}