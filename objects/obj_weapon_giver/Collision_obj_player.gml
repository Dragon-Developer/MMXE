array_push(other.components.get(ComponentWeaponUse).weapon_list, weapon)
array_push(other.components.get(ComponentWeaponUse).weapon_ammo, other.components.get(ComponentWeaponUse).weapon_max_ammo)
instance_destroy(self);