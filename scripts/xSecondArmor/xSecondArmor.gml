// For simplifying purposes, I am going to write all of these parts in the same script. 
function XSecondArmorHead() : HeadPartBase() constructor{
	//nothing special
	self.sprite_name = "/x2/helm"//this is more for filepath.
	self.armor_name = "Second Armor Head"
	self.apply_armor_effects = function(_player){
		//array_push(_player.get(ComponentWeaponUse).weapon_list, SecondArmorRadar)
	}
	self.description = "Gives the user a radar to locate collectibles"
}

function XSecondArmorBody() : BodyPartBase() constructor{
	//i think this has 2/3 reduction?
	self.damage_rate = 0.5;
	self.armor_name = "Second Armor Body"
	self.apply_armor_effects = function(_player){
		var _weps = _player.get(ComponentWeaponUse)
		array_push(_weps.weapon_list, GigaCrush)
	}
	self.sprite_name = "/x2/body"//this is more for filepath.
	self.description = "Halves incoming damage. Taken damage is turned into giga energy."
}

function XSecondArmorArms() : ArmsPartBase() constructor{
	//drill buster!
	self.sprite_name = "/x2/arms"//this is more for filepath.
	self.buster_weapon = xBusterX2;
	self.armor_name = "Second Armor Arms"
	self.description = "Gives the user a double buster."
}

function XSecondArmorBoot() : BootPartBase() constructor{
	//increased dash speed
	self.sprite_name = "/x2/legs"//this is more for filepath.
	self.armor_name = "Second Armor Boots"
	self.step_armor_effects = function(){
		//even a comment stops the compiler from deleting empty functions
	};
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		add_air_dash(_player, self);
		with(_player){
			struct_set(states.dash_air, "interval", states.dash.interval)
		}
	}
	self.description = "Gives the user an air dash. This air dash is unusally long."
}

function GigaCrush() : ProjectileWeapon() constructor{
	self.data = [GigaCrushData];
	self.charge_limit = 0;
	self.cost = 7;
	self.not_selectable = true;
	self.giga = true;
	self.title = "GIGA CRUSH";
	self.description = "LARGE RELEASE OF ABSORBED DAMAGE"
	
	self.weapon_palette = global.player_character[global.local_player_index].default_palette;
}

function GigaCrushData(): StateBasedData() constructor {
	self.state_name = "giga crush"
	self.init = function(_player){
		with(_player){
			fsm.add(other.state_name,{
				enter: function() {
					self.physics.set_grav(new Vec2(0,0));
					self.timer = CURRENT_FRAME;
					self.physics.set_speed(0, 0);
					self.publish("animation_play", { name: "giga_crush" });
				},
				step: function() {
					if(timer == CURRENT_FRAME + 142){
						PROJECTILES.create_projectile(get_instance().x, get_instance().y, dir, GenkiDamaData, get(ComponentWeaponUse), ["player"], 0);
					}
				},
				leave: function() {
					self.physics.set_grav(self.physics.grav_default);
				}
			})
			.add_transition("t_animation_end", other.state_name, "fall")
		}
	}
}