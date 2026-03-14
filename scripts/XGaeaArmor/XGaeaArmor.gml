// For simplifying purposes, I am going to write all of these parts in the same script. 
function XGaeaArmorHead() : HeadPartBase() constructor{
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

function XGaeaArmorBody() : BodyPartBase() constructor{
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

function XGaeaArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.sprite_name = "/gaea/arms"//this is more for filepath.
	self.armor_name = "gaea Armor Arms"
	self.extra_charge_limit = 2;
	
	self.description = "Does not allow for charging special weapons, but buster shots deal extreme amounts of damage."
	self.selectable = false;
	self.buster_weapon = GaeaBuster;
	self.set_bonus = XGaeaArmorSetBonus;
}

function XGaeaArmorBoot() : BootPartBase() constructor{
	self.sprite_name = "/gaea/legs"//this is more for filepath.
	self.armor_name = "gaea Armor Legs"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		_player.states.walk.speed *= 0.85;
		_player.states.dash.speed *= 0.8;
		_player.get(ComponentPhysics).grav = new Vec2(0,1/3);
		_player.get(ComponentPhysics).grav_default = new Vec2(0,1/3);
		_player.get(ComponentDamageable).immune_to_damage_zones = true;
	}
	
	self.description = "Prevents the user from dying from spikes. Lowers dash speed due to bulky plating."
	self.selectable = false;
	self.set_bonus = XGaeaArmorSetBonus;
}

function XGaeaArmorSetBonus(_player){
	_player.states.walk.speed *= 0.85;
	_player.states.dash.speed *= 0.9;
	var _weps = _player.get(ComponentWeaponUse)
	array_push(_weps.weapon_list, GenkiDama)
	_weps.set_weapons(_weps.weapon_list)
	_weps.current_weapon[2] += 1;
	_weps.current_weapon[3] += 1;
}