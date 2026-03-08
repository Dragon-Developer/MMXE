// For simplifying purposes, I am going to write all of these parts in the same script. 
function XFirstArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/x1/helm"//this is more for filepath.
	self.armor_name = "First Armor Head"
	
	self.description = "Allows breaking of weak blocks above the user."
}

function XFirstArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 0.4;
	self.armor_name = "First Armor Body"
	self.sprite_name = "/x1/body"//this is more for filepath.
	self.description = "Lowers damage by 60 percent."
}

function XFirstArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.buster_weapon = xBuster;//the weapon data that xBuster will be swapped out for.
	self.sprite_name = "/x1/arms"//this is more for filepath.
	self.armor_name = "First Armor Arms"
	self.description = "Gives the user the drill buster."
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		_player.get(ComponentWeaponUse).weapon_use_rate = 0.75;
		_player.get(ComponentWeaponUse).charge.charge_limit += self.extra_charge_limit;
	}
}

function XFirstArmorBoot() : BootPartBase() constructor{
	//increased dash speed
	self.sprite_name = "/x1/legs"//this is more for filepath.
	self.armor_name = "First Armor Legs"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		
		//self.add_slide(_player);
		_player.states.dash.speed *= 1.25;
	}
	self.description = "Increases dash speed by 25 percent."
}