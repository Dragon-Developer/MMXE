// For simplifying purposes, I am going to write all of these parts in the same script. 
function XGaeaArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/gaea/helm"//this is more for filepath.
	self.description = "All weapons deal 2 extra damage. Previously disabled due to instability"
	self.selectable = false;
}

function XGaeaArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 0.5;
	self.sprite_name = "/gaea/body"//this is more for filepath.
	
	self.description = "Decreases damage by 2/3. Also allows the use of a giga attack that deals extreme damage in close range."
	self.selectable = false;
}

function XGaeaArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.sprite_name = "/gaea/arms"//this is more for filepath.
	self.armor_name = "gaea Armor Arms"
	self.extra_charge_limit = 2;
	
	self.description = "Does not allow for charging special weapons, but buster shots deal extreme amounts of damage."
	self.selectable = false;
}

function XGaeaArmorBoot() : BootPartBase() constructor{
	//increased dash speed
	self.sprite_name = "/gaea/legs"//this is more for filepath.
	self.buster_weapon = GaeaBuster;
	self.armor_name = "gaea Armor Legs"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		_player.states.walk.speed *= 0.85;
		_player.states.dash.speed *= 0.8;
	}
	
	self.description = "Prevents the user from dying from spikes. Lowers dash speed due to bulky plating."
	self.selectable = false;
}