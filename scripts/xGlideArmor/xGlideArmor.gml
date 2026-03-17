// For simplifying purposes, I am going to write all of these parts in the same script. 
function XGlideArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/gaea/helm"//this is more for filepath.
	self.description = "All weapons deal 2 extra damage. Previously disabled due to instability"
	self.armor_name = "gaea Armor Helm"
	self.selectable = false;
	
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		_player.get(ComponentWeaponUse).damage_increase = 1;
		_player.get(ComponentWeaponUse).charge.charge_time = [30, 90, 150, 210, 270, 330, 400]
	}
	self.set_bonus = XGaeaArmorSetBonus;
}

function XGlideArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 1/3;
	self.sprite_name = "/gaea/body"//this is more for filepath.
	self.armor_name = "gaea Armor Chest"
	
	self.description = "Decreases damage by 2/3. Also allows the use of a giga attack that deals extreme damage in close range."
	self.selectable = false;
	
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		_player.get(ComponentPhysics).terminal_velocity = 8;
	}
	self.set_bonus = XGaeaArmorSetBonus;
}

function XGlideArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.sprite_name = "/x7/arms"//this is more for filepath.
	self.armor_name = "gaea Armor Arms"
	self.extra_charge_limit = 2;
	
	self.description = "Does not allow for charging special weapons, but buster shots deal extreme amounts of damage."
	self.selectable = false;
	self.buster_weapon = GaeaBuster;
	self.set_bonus = XGaeaArmorSetBonus;
}

function XGlideArmorBoot() : BootPartBase() constructor{
	self.sprite_name = "/x7/legs"//this is more for filepath.
	self.armor_name = "glide Armor Legs"
	self.apply_armor_effects = function(_player){
		
	}
	
	self.description = "Gives the user the glide, an ability that limits falling but moves slowly"
	self.selectable = false;
	self.set_bonus = XGaeaArmorSetBonus;
}