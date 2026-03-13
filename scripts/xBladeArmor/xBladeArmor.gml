// For simplifying purposes, I am going to write all of these parts in the same script. 
function XBladeArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/blade/helm"//this is more for filepath.
}

function XBladeArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 0.5;
	self.sprite_name = "/blade/body"//this is more for filepath.
}

function XBladeArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.sprite_name = "/blade/arms"//this is more for filepath.
}

function XBladeArmorBoot() : BootPartBase() constructor{
	//increased dash speed
	self.sprite_name = "/blade/legs"//this is more for filepath.
	self.armor_name = "Blade Armor Legs"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		
	}
	
	self.description = "Gives the user the mach dash. The mach dash can be aimed."
}