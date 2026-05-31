function XAresArmorArms() : X8ArmsBase() constructor{
	self.armor_name = "Orion Arms";
	self.extra_charge_limit = 3;
	self.buster_weapon = AresBuster;
	self.apply_armor_effects = function(_player){
		_player.get(ComponentWeaponUse).charge.charge_limit = self.extra_charge_limit;
		
		set_default_palette(_player,[ #a0f080, #38a858, #185040, #a0f080, #38a858, #185040, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
	}
	self.description = "Gives the user the homing buster."
}

function XAresArmorHelm() : X8HelmBase() constructor{
	self.armor_name = "Orion Helmet";
	self.apply_armor_effects = function(_player){
		
		set_default_palette(_player, [ #a0f080, #38a858, #185040, #a0f080, #38a858, #185040, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
	}
	self.description = "Passively charges giga energy. Gigas that automatically recharge will recharge faster"
}

function XAresArmorBoot() : X8BootBase() constructor{
	self.armor_name = "Orion Boots";
	self.apply_armor_effects = function(_player){
		_player.get(ComponentPhysics).terminal_velocity *= 2/3;
		_player.get(ComponentPhysics).grav_default.y *= 0.85
		add_air_dash(_player)
		
		set_default_palette(_player,[ #a0f080, #38a858, #185040, #a0f080, #38a858, #185040, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
	}
	self.description = "Lowers terminal velocity, allowing more time to react to things below you."
}

function XAresArmorBody() : X8BodyBase() constructor{
	self.armor_name = "Orion Body";
	self.apply_armor_effects = function(_player){
		_player.get(ComponentDamageable).red_health_active = true;
		_player.get(ComponentDamageable).red_health_percentage = 1.5;
		_player.get(ComponentDamageable).red_health_interval *= 2;
		_player.get(ComponentDamageable).invuln_time *= 1.25
		_player.get(ComponentPlayerMove).states.hurt.speed *= 7
		_player.get(ComponentPlayerMove).states.hurt.strength *= 2
		//_player.get(ComponentPlayerMove).states.hurt.rate *= 0.75
		
		set_default_palette(_player, [ #a0f080, #38a858, #185040, #a0f080, #38a858, #185040, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
	}
	self.description = "Makes the user gain 150% of damage as red health, but sends the user flying when hit. Also heals red health half as fast."
}