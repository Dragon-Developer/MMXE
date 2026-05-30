// For simplifying purposes, I am going to write all of these parts in the same script. 
function XForceArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/x1/helm"//this is more for filepath.
	self.armor_name = "force Armor Head"
	
	self.description = "Allows breaking of weak blocks above the user."
}

function XForceArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 0.4;
	self.armor_name = "force Armor Body"
	self.sprite_name = "/x1/body"//this is more for filepath.
	self.description = "Lowers damage by 60 percent."
}

function XForceArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.buster_weapon = xBuster;//the weapon data that xBuster will be swapped out for.
	self.sprite_name = "/x1/arms"//this is more for filepath.
	self.armor_name = "force Armor Arms"
	self.description = "Gives the user the drill buster."
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		_player.get(ComponentWeaponUse).weapon_use_rate = 0.9;
		_player.get(ComponentWeaponUse).charge.charge_limit = self.extra_charge_limit;
	}
}

function XForceArmorBoot() : BootPartBase() constructor{
	//increased dash speed
	self.sprite_name = "/x1/legs"//this is more for filepath.
	self.armor_name = "force Armor Legs"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		
		if _player.fsm.state_exists("dash")
			_player.states.dash.speed *= 1.25;
		else
			add_dash(_player)
	}
	self.description = "Increases dash speed by 25 percent."
}