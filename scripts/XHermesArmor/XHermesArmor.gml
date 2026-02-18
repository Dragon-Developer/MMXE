function XHermesArmorArms() : ArmsPartBase() constructor{
	self.sprite_name = "/hermes/arms"//this is more for filepath.
	self.armor_name = "Hermes Arms";
	self.extra_charge_limit = 2;
	self.buster_weapon = HermesBuster;
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		//get the weaponuse component, get its charge object, get its charge COMPONENT, then add 1 to charge limits
		_player.get(ComponentWeaponUse).charge.charge_limit += self.extra_charge_limit;
		_player.get(ComponentWeaponUse).charge_time = [30, 105, 180, 255];
	}
}