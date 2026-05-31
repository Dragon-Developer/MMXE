function XCharacter() : BaseCharacter() constructor{
	self.weapons = [xBuster, XSaber, ElectricWeb, ShotgunIce, TwinSlasher];
	
	self.possible_armors = [
		[noone, XFirstArmorHead, XSecondArmorHead, XThirdArmorHead, XForceArmorHead, XFalconArmorHead, XGaeaArmorHead, XBladeArmorHead, XShadowArmorHead, XGlideArmorHead, XNeutralArmorHelm, XIcarusArmorHelm, XHermesArmorHelm, XAresArmorHelm],//heads
		[noone, XFirstArmorArms, XSecondArmorArms, XThirdArmorArms, XForceArmorArms, XFalconArmorArms, XGaeaArmorArms, XBladeArmorArms, XShadowArmorArms, XGlideArmorArms, XNeutralArmorArms, XIcarusArmorArms, XHermesArmorArms, XAresArmorArms],//Armss
		[noone, XFirstArmorBody, XSecondArmorBody, XThirdArmorBody, XForceArmorBody, XFalconArmorBody, XGaeaArmorBody, XBladeArmorBody, XShadowArmorBody, XGlideArmorBody, XNeutralArmorBody, XIcarusArmorBody, XHermesArmorBody, XAresArmorBody],//Bodys
		[noone, XFirstArmorBoot, XSecondArmorBoot, XThirdArmorBoot, XForceArmorBoot, XFalconArmorBoot, XGaeaArmorBoot, XBladeArmorBoot, XShadowArmorBoot, XGlideArmorBoot, XNeutralArmorBoot, XIcarusArmorBoot, XHermesArmorBoot, XAresArmorBoot],//Boots
		[noone, ArmorDoubleGear]//no full sets yet but ult armor would be good here
	];
	self.init = function(_player){
		
		self.init_default(_player);
		add_dash(_player);
		add_wall_jump(_player);
		add_zipline(_player)
	}
}