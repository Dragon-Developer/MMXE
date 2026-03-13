// For simplifying purposes, I am going to write all of these parts in the same script. 
function XFalconArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/x2/helm"//this is more for filepath.
	self.armor_name = "Second Armor Head"
	self.apply_armor_effects = function(_player){
		//array_push(_player.get(ComponentWeaponUse).weapon_list, SecondArmorRadar)
	}
	self.description = "Gives the user a radar to locate collectibles"
}

function XFalconArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 0.5;
	self.armor_name = "Second Armor Body"
	self.sprite_name = "/x2/body"//this is more for filepath.
	self.description = "Halves incoming damage. Taken damage is turned into giga energy."
}

function XFalconArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.sprite_name = "/x2/arms"//this is more for filepath.
	self.armor_name = "Second Armor Arms"
	self.description = "Gives the user a double buster."
}

function XFalconArmorBoot() : BootPartBase() constructor{
	//increased dash speed
	self.sprite_name = "/falcon/legs"//this is more for filepath.
	self.armor_name = "Second Armor Boots"
	self.step_armor_effects = function(){
		//even a comment stops the compiler from deleting empty functions
	};
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		add_falcon_flight(_player);
	}
	self.description = "Gives the user an air dash. This air dash is unusally long."
}