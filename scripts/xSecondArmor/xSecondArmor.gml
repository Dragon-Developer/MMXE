// For simplifying purposes, I am going to write all of these parts in the same script. 
function XSecondArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/x2/helm"//this is more for filepath.
}

function XSecondArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 0.4;
	self.armor_name = "First Armor Body"
	self.sprite_name = "/x2/body"//this is more for filepath.
}

function XSecondArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.sprite_name = "/x2/arms"//this is more for filepath.
}

function XSecondArmorBoot() : BootPartBase() constructor{
	//increased dash speed
	self.sprite_name = "/x2/legs"//this is more for filepath.
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		self.add_air_dash(_player);
	}
}