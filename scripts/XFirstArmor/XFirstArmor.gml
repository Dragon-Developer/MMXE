// For simplifying purposes, I am going to write all of these parts in the same script. 
function XFirstArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/x1/helm"//this is more for filepath.
}

function XFirstArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 0.4;
	self.armor_name = "First Armor Body"
	self.sprite_name = "/x1/body"//this is more for filepath.
}

function XFirstArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.sprite_name = "/x1/arms"//this is more for filepath.
}

function XFirstArmorBoot() : BootPartBase() constructor{
	//increased dash speed
	self.sprite_name = "/x1/legs"//this is more for filepath.
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		_player.states.dash.speed *= 1.25;
	}
}