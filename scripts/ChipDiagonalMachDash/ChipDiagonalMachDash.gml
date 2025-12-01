function ChipDiagonalMachDash(): ArmorBase() constructor{
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
	self.armor_name = "diagonal mach dash";
		with(_player){
			self.states.mach_dash.only_cardinals = false;
		}
	}
}

function ChipDashLengthIncrease(): ArmorBase() constructor{
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
	self.armor_name = "long dash";
		with(_player){
			self.states.dash.interval *= 1.25;
			if(struct_exists(self.states, "mach_dash"))
				self.states.mach_dash.interval *= 1.25;
			if(struct_exists(self.states, "dash_air"))
				self.states.dash_air.interval *= 1.25;
		}
	}
}

function ChipHyperDash(): ArmorBase() constructor{
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
	self.armor_name = "hyper dash";
		with(_player){
			self.states.dash.speed *= 1.2;
			self.states.dash.interval /= 1.2;
			if(struct_exists(self.states, "mach_dash")){
				self.states.mach_dash.speed *= 1.2;
				self.states.mach_dash.interval /= 1.2;
			}
			if(struct_exists(self.states, "dash_air")){
				self.states.dash_air.speed *= 1.2;
				self.states.dash_air.interval /= 1.2;
			}
		}
	}
}

function ChipSpeedster(): ArmorBase() constructor{
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
	self.armor_name = "speedster";
		with(_player){
			self.states.walk.speed *= 1.1;
		}
	}
}

function ChipJumper(): ArmorBase() constructor{
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
	self.armor_name = "jumper";
		with(_player){
			self.states.jump.strength *= 1.2;
		}
	}
}