// For simplifying purposes, I am going to write all of these parts in the same script. 
function XshadowArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/shadow/helm"//this is more for filepath.
	self.armor_name = "shadow Armor Helm"
}

function XshadowArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 0.5;
	self.sprite_name = "/shadow/body"//this is more for filepath.
	self.armor_name = "shadow Armor Body"
}

function XshadowArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.sprite_name = "/shadow/arms"//this is more for filepath.
	self.armor_name = "shadow Armor Arms"
}

function XshadowArmorBoot() : BootPartBase() constructor{
	//increased dash speed
	self.sprite_name = "/shadow/legs"//this is more for filepath.
	self.armor_name = "shadow Armor Legs"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		add_mach_dash(_player)
	}
}