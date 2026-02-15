function ArmsPartBase() : ArmorBase() constructor{
	self.buster_weapon = HermesBuster;//the weapon data that xBuster will be swapped out for.
	self.extra_charge_limit = 1;//the increase to the charge limit the character gets
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		//get the weaponuse component, get its charge object, get its charge COMPONENT, then add 1 to charge limits
		_player.get(ComponentWeaponUse).charge.charge_limit += self.extra_charge_limit;
	}
}