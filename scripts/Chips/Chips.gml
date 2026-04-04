function ChipBase(): ArmorBase() constructor{
	self.icon = "chip_dummy"
}

function ChipDiagonalMachDash(): ArmorBase() constructor{
	self.armor_name = "diagonal mach dash";
	self.icon = "chip_dummy"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		_player.states.mach_dash.only_cardinals = false;
	}
}

function ChipDasher(): ArmorBase() constructor{
	self.armor_name = "long dash";
	self.icon = "chip_dasher"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
			_player.states.dash.interval *= 1.5;
			if(struct_exists(_player.states, "mach_dash"))
				_player.states.mach_dash.interval *= 1.25;
			if(struct_exists(_player.states, "dash_air"))
				_player.states.dash_air.interval *= 1.25;
	}
}

function ChipHyperDash(): ArmorBase() constructor{
	self.armor_name = "hyper dash";
	self.icon = "chip_hyper_dash"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
			_player.states.dash.speed *= 1.3
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
}

function ChipSpeedster(): ArmorBase() constructor{
	self.armor_name = "speedster";
	self.icon = "chip_speedster"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
			_player.states.walk.speed *= 1.2;
	}
}

function ChipJumper(): ArmorBase() constructor{
	self.armor_name = "jumper";
	self.icon = "chip_jumper"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
			_player.states.jump.strength *= 1.2;
	}
}

function ChipClinger(): ArmorBase() constructor{
	self.armor_name = "clinger";
	self.icon = "chip_clinger"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
			_player.states.wall_slide.speed *= 0.5;
	}
}

function ChipAirDasher(): BootPartBase() constructor{
	self.armor_name = "air dasher";
	self.icon = "chip_air_dasher"
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		add_air_dash(_player)
	}
}