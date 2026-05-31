function XHermesArmorArms() : X8ArmsBase() constructor{
	self.armor_name = "Hermes Arms";
	self.extra_charge_limit = 4;
	self.buster_weapon = HermesBuster;
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		//get the weaponuse component, get its charge object, get its charge COMPONENT, then add 1 to charge limits
		_player.get(ComponentWeaponUse).charge.charge_limit = self.extra_charge_limit;
		
		set_default_palette(_player, [ #6068f8, #3018c8, #201088, #6068f8, #3018c8, #201088, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
		//set_default_palette(_player);
	}
	self.set_bonus = HermesArmorSetBonus;
	self.description = "Gives the user the triple buster. This buster fires 2 extra shots at 45 degrees when fully charged."
}

function XHermesArmorHelm() : X8HelmBase() constructor{
	self.armor_name = "Hermes Helmet";
	self.apply_armor_effects = function(_player){
		_player.get(ComponentWeaponUse).charge.charge_time = [15, 70, 105, 145, 180, 220, 260]
		set_default_palette(_player, [ #6068f8, #3018c8, #201088, #6068f8, #3018c8, #201088, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
	}
	self.set_bonus = HermesArmorSetBonus;
	self.description = "Halves charge times."
}

function XHermesArmorBoot() : X8BootBase() constructor{
	self.armor_name = "Hermes Boots";
	self.apply_armor_effects = function(_player){
		set_default_palette(_player, [ #6068f8, #3018c8, #201088, #6068f8, #3018c8, #201088, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
		
		_player.states.dash.speed *= 1.5;
		_player.states.walk.speed *= 1.5;
		add_air_dash(_player)
		
		with(obj_camera){
			components.get(ComponentCamera).use_movement_limits = false;
		}
		
		with(_player){
			self.fsm.add("dash", {
				enter: function() {//
					WORLD.play_sound(self.states.dash.sound);
					var _inst = self.get_instance();
						WORLD.spawn_particle(new DashParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
					self.timer = CURRENT_FRAME + self.states.dash.interval;
					self.dash_dir = self.dir;
					if(self.dash_dir == 0)
						self.dash_dir = self.hdir;
					self.publish("animation_play", { name: self.states.dash.animation });
				
					//extra jargon
					if(variable_struct_exists(self.states, "melee"))
						self.states.melee.animation = "undefined"
					
					get(ComponentDamageable).invuln_offset = CURRENT_FRAME + self.states.dash.interval;
				},
				step: function() {
					self.set_hor_movement(self.dash_dir);
					if(CURRENT_FRAME >= self.timer - self.states.dash.interval + 2)
						self.current_hspd = self.states.dash.speed;	
					if(CURRENT_FRAME mod 4 == 0){
						var _inst = self.get_instance();
						WORLD.spawn_particle(new DustParticle(_inst.x- 16 * self.dir, _inst.y + 8, self.dir))
					}
				},
				leave: function() {
					self.dash_jump = self.input.get_input_pressed("jump");
					if (!self.dash_jump && self.physics.is_on_floor())
						self.current_hspd = self.states.walk.speed;	
					get(ComponentDamageable).invuln_offset = CURRENT_FRAME + 1;
				}
			})
		}
	}
	self.set_bonus = HermesArmorSetBonus;
	self.description = "Increases movement speed and dash speed. Dash is invincible."
}

function XHermesArmorBody() : X8BodyBase() constructor{
	self.armor_name = "Hermes Body";
	self.apply_armor_effects = function(_player){
		set_default_palette(_player, [ #6068f8, #3018c8, #201088, #6068f8, #3018c8, #201088, #f0f0f0, #989898, #707070, #18e0c0, #009080]);
		
		_player.get(ComponentDamageable).damage_offset = 2;
		_player.get(ComponentDamageable).red_health_active = true;
	}
	self.set_bonus = HermesArmorSetBonus;
	self.description = "Converts taken damage into red health. Red health is healed slowly over time."
}

function HermesArmorSetBonus( _player, _palette = [ #68a8f8, #5868f8, #3018d0, #68a8f8, #5868f8, #3018d0, #f0f0f0, #989898, #707070, #18e0c0, #009080]){
	//log(_player.get(ComponentArmorHandler).armor_parts)
	if _palette[0] = #68a8f8 {
		var _weps = _player.get(ComponentWeaponUse)
		array_push(_weps.weapon_list, XDrive)
		_player.get(ComponentWeaponUse).set_weapons(_player.get(ComponentWeaponUse).weapon_list)
		_player.get(ComponentWeaponUse).weapon_selection[3]++;
	}
	
	for(var r = 0; r < array_length(_player.get(ComponentArmorHandler).armor_parts[0]); r++){
		var _armor = _player.get(ComponentArmorHandler).armor_parts[0][r]
		_armor.palette = _palette
	}
}