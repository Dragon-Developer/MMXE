remove_dash(other.components.get(ComponentPlayerMove))
remove_wall_jump(other.components.get(ComponentPlayerMove))
remove_wall_slide(other.components.get(ComponentPlayerMove))
other.components.get(ComponentWeaponUse).weapon_list = [xBusterX2]
instance_destroy(self)