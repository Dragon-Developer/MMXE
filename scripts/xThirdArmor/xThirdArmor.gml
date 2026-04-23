// For simplifying purposes, I am going to write all of these parts in the same script. 
function XThirdArmorHead() : HeadPartBase() constructor{
	//minimap
	self.sprite_name = "/x3/helm"
	self.armor_name = "Third Armor Head"
	self.apply_armor_effects = function(_player){
		with(_player){
			get_instance().components.add([ComponentMinimap]);
			get(ComponentMinimap).init();
		}
	}
	self.description = "Gives the user a map to see nearby surroundings."
}

function XThirdArmorBody() : BodyPartBase() constructor{
	self.damage_rate = 0.5;
	self.armor_name = "Third Armor Body"
	self.sprite_name = "/x3/body"//shield
	self.description = "Halves damage when hit. A shield is then generated that will further halve damage."
	
	
}

function XThirdArmorArms() : ArmsPartBase() constructor{
	self.extra_charge_limit = 4
	self.buster_weapon = xBusterX3;
	self.sprite_name = "/x3/arms"//combo buster
	self.armor_name = "Third Armor Arms"
	self.description = "Gives the user the combo buster. The projectiles can be combined if fired quickly."
}

function XThirdArmorBoot() : BootPartBase() constructor{
	self.sprite_name = "/x3/legs"
	self.armor_name = "Third Armor Boots"
	self.apply_armor_effects = function(_player){// air dash and up dash
		add_variable_dash(_player)
		add_air_dash(_player, self);
	}
	self.description = "Gives the user the variable air dash. This dash can be aimed upwards."
}