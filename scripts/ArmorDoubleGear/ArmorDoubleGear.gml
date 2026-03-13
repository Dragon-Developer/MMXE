function ArmorDoubleGear() : ArmorBase() constructor{

	self.armor_name = "Double Gear";
	self.description = "Gives the user the double gear system."
	
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		var _weps = _player.get(ComponentWeaponUse)
		array_push(_weps.weapon_list, PowerGear)
		array_push(_weps.weapon_list, SpeedGear)
		_weps.set_weapons(_weps.weapon_list)
		_weps.current_weapon[2] += 2;
		_weps.current_weapon[3] += 2;
		
		var _handler = ENTITIES.create_instance(obj_double_gear_handler);
		
		_handler.components.find("animation").set_subdirectories([ "/normal"]);
		_handler.components.find("animation").draw_in_gui = true;
		_handler.components.publish("character_set", "gear");
		_handler.components.publish("armor_set",[]);
		_handler.components.publish("animation_play", { name: "resting" });
	}
}