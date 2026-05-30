function XNeutralArmorArms() : X8ArmsBase() constructor{
	self.armor_name = "Neutral Arms";
	self.extra_charge_limit = 3;
	self.buster_weapon = HermesBuster;
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		//get the weaponuse component, get its charge object, get its charge COMPONENT, then add 1 to charge limits
		_player.get(ComponentWeaponUse).charge.charge_limit = self.extra_charge_limit;
		
		set_default_palette(_player, [ #f8f090, #c8b850, #a88040, #b06050, #784028, #601810, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
		//set_default_palette(_player);
	}
	self.description = "Applies standard issue Hunter Buster MK.11"
}

function XNeutralArmorHelm() : X8HelmBase() constructor{
	self.armor_name = "Neutral Helmet";
	self.apply_armor_effects = function(_player){
		set_default_palette(_player, [ #f8f090, #c8b850, #a88040, #b06050, #784028, #601810, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
	}
	self.description = "Does nothing, but sure does look cool."
}

function XNeutralArmorBoot() : X8BootBase() constructor{
	self.armor_name = "Neutral Boots";
	self.apply_armor_effects = function(_player){
		add_air_dash(_player)

		set_default_palette(_player, [ #f8f090, #c8b850, #a88040, #b06050, #784028, #601810, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
	}
	self.description = "Loads the user with standard issue Air Dash."
}

function XNeutralArmorBody() : X8BodyBase() constructor{
	self.armor_name = "Neutral Body";
	self.damage_rate = 0.5;
	self.apply_armor_effects = function(_player){
		_player.states.hurt.speed = -0.25;
		
		set_default_palette(_player, [ #f8f090, #c8b850, #a88040, #b06050, #784028, #601810, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
	}
	self.description = "lowers knockback effect."
}