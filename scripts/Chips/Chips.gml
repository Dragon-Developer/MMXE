function ChipBase(): ArmorBase() constructor{
	self.icon = "chip_dummy"
	self.description = "Well, it's a chip, that's for sure."
}

function ChipHeart(): ChipBase() constructor{
	self.armor_name = "heart up";
	self.icon = "chip_dummy"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		global.player_data.max_health++;
	}
	self.description = "Gives you one extra point of maximum health. We finally recreated the heart tank!"
}

function ChipWeaponUp(): ChipBase() constructor{
	self.armor_name = "weapon up";
	self.icon = "chip_dummy"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		global.player_data.max_health++;
	}
	self.description = "Gives you one extra point of maximum Weapon Energy. Axl's hobby project!"
	if(global.character_ref[global.character_index] == AxlCharacter)
		self.description = string_replace(self.description, "Axl's", "Your")
}

function ChipDiagonalMachDash(): ChipBase() constructor{
	self.armor_name = "diagonal mach dash";
	self.icon = "chip_dummy"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		_player.states.mach_dash.only_cardinals = false;
	}
	self.description = "Lets you mach dash diagonally. Now you know why the arrow does diagonals!"
}

function ChipDasher(): ChipBase() constructor{
	self.armor_name = "long dash";
	self.icon = "chip_dasher"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
			_player.states.dash.interval *= 1.25;
			if(struct_exists(_player.states, "mach_dash"))
				_player.states.mach_dash.interval *= 1.2;
			if(struct_exists(_player.states, "dash_air"))
				_player.states.dash_air.interval *= 1.2;
	}
	self.description = "Increases the length of your dashes. "
}

function ChipHyperDash(): ChipBase() constructor{
	self.armor_name = "hyper dash";
	self.icon = "chip_hyper_dash"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
			_player.states.dash.speed *= 1.2
			_player.states.dash.interval /= 1.2;
			if(struct_exists(_player.states, "mach_dash")){
				_player.states.mach_dash.speed *= 1.2;
				_player.states.mach_dash.interval /= 1.2;
			}
			if(struct_exists(_player.states, "dash_air")){
				_player.states.dash_air.speed *= 1.2;
				_player.states.dash_air.interval /= 1.2;
			}
	}
	self.description = "Speeds up your dash, but lowers your dash length."
}

function ChipSpeedster(): ChipBase() constructor{
	self.armor_name = "speedster";
	self.icon = "chip_speedster"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
			_player.states.walk.speed *= 1.1;
	}
	self.description = "Makes you walk faster. Shouldnt really walk everywhere, though."
}

function ChipJumper(): ChipBase() constructor{
	self.armor_name = "jumper";
	self.icon = "chip_jumper"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
			_player.states.jump.strength *= 1.1;
	}
	self.description = "Makes your jumps go a little higher. Good if you're too lazy to double jump."
}

function ChipClinger(): ChipBase() constructor{
	self.armor_name = "clinger";
	self.icon = "chip_clinger"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
			_player.states.wall_slide.speed *= 0.75;
	}
	self.description = "Slows down wall slide speed. Stops you from stubbing your toes on spikes."
}

function ChipWeighter(): ChipBase() constructor{
	self.armor_name = "weighter";
	self.icon = "chip_weighter"
	self.apply_armor_effects = function(_player){
		_player.get(ComponentPhysics).terminal_velocity += 1;
		_player.get(ComponentPhysics).terminal_velocity_default += 1;
	}
	self.description = "Increase your terminal velocity. Now you can fall a little faster!"
}

function ChipDamager(): ChipBase() constructor{
	self.armor_name = "damager";
	self.icon = "chip_damager"
	self.apply_armor_effects = function(_player){
		_player.get(ComponentWeaponUse).damage_increase += 1;
	}
	self.description = "Increases damage by 1. Good if you have something you REALLY want gone!"
}

function ChipAirDasher(): BootPartBase() constructor{
	self.armor_name = "air dasher";
	self.icon = "chip_air_dasher"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		add_air_dash(_player)
	}//i know its probably R&D but there is no & character in the mmx set
	self.description = "Gives you an air dash. RND went through hell and back for this one!"
}