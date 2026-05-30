//remove_dash(other.components.get(ComponentPlayerMove));
remove_wall_jump(other.components.get(ComponentPlayerMove));
remove_wall_slide(other.components.get(ComponentPlayerMove));
other.components.get(ComponentPlayerMove).states.jump.dash_jump_enabled = false;
other.components.get(ComponentWeaponUse).weapon_list = [xBusterX2];
global.availible_characters[global.character_index].weapons = [xBusterX2];
global.availible_characters[global.character_index].states.jump.dash_jump_enabled = false;
other.components.get(ComponentDamageable).health = 8;
other.components.get(ComponentDamageable).health_max = 8;
other.components.get(ComponentWeaponUse).weapon_max_ammo = 8;
other.components.get(ComponentWeaponUse).weapon_ammo = [8];
other.components.get(ComponentWeaponUse).reset();
instance_destroy(self)