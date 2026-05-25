function XIcarusArmorArms() : X8ArmsBase() constructor{
	self.armor_name = "Icarus Arms";
	self.extra_charge_limit = 3;
	self.buster_weapon = IcarusBuster;
	self.apply_armor_effects = function(_player){
		_player.get(ComponentWeaponUse).charge.charge_limit = self.extra_charge_limit;
		
		set_default_palette(_player,[ #f04010, #903010, #502008, #f04010, #903010, #502008, #f0f0f0, #989898, #707070, #f8b878, #f04010]);
	}
	self.set_bonus = IcarusArmorSetBonus;
	self.description = "Gives the user the kamehameha."
}

function XIcarusArmorHelm() : X8HelmBase() constructor{
	self.armor_name = "Icarus Helmet";
	self.apply_armor_effects = function(_player){
		with(_player){
			fsm.add_child("air", "jump", {
				enter: function() {
					self.physics.set_grav(self.physics.grav_default);
					var _inst = self.get_instance();
					if(self.input.get_input("down") && self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y + 1, obj_collision_semisolid)){
						self.fsm.change("fall");
						_inst.y += 3;
						self.physics.set_vspd(1);
						return;
					}
					_inst.y -= self.states.jump.strength;
					with(obj_camera){
						components.get(ComponentCamera).step();
					}
				
					if(self.physics.is_on_floor(self.ground_distance)){
						self.publish("animation_play", { name: self.states.jump.animation });
						double_jumps = self.states.jump.count - 1;
					}else{ 
						double_jumps--;
						self.publish("animation_play", { name: self.states.jump.double_jump_animation });
					
						if(global.settings.extra_particles)
							WORLD.spawn_particle(new DustParticle(_inst.x, _inst.y + 16, self.dir))
					}
				
					WORLD.play_sound(self.states.jump.sound);
					self.input.__useBuffer = false;
					self.fsm.inherit();
					
					PROJECTILES.create_projectile(self.get_instance().x, self.get_instance().y, self.dir, XIcarusArmorHeadbuttProjectile, get(ComponentWeaponUse), ["player"], 0);
					
					self.physics.set_vspd(-(self.states.jump.strength - self.physics.get_grav().y));
					if ((self.fsm.get_previous_state() == "dash" || self.fsm.get_previous_state() == "dash_air" || self.input.get_input("dash") && global.settings.PSX_Style_Dash_Jumping) && self.fsm.state_exists("dash")) && self.states.jump.dash_jump_enabled{
						self.current_hspd = self.states.dash.speed;
						if(global.settings.extra_particles)
							WORLD.spawn_particle(new SparkParticle(_inst.x, _inst.y + 16, self.dir))
					} else if(!self.states.jump.dash_jump_enabled) {
						self.current_hspd = self.states.walk.speed;
					}
					self.timer = CURRENT_FRAME;
				},
				step: function() {
					self.set_hor_movement();
					if(self.current_hspd != self.states.dash.speed && CURRENT_FRAME - self.timer < 5) && ((self.fsm.get_previous_state() == "dash" || self.fsm.get_previous_state() == "dash_air" || self.input.get_input("dash") && global.settings.PSX_Style_Dash_Jumping) && self.fsm.state_exists("dash")) && self.states.jump.dash_jump_enabled{
						self.current_hspd = self.states.dash.speed;
						var _inst = self.get_instance();
						if(global.settings.extra_particles)
							WORLD.spawn_particle(new SparkParticle(_inst.x, _inst.y + 16, self.dir))
					}
				}
			}).add("wall_jump", {
			enter: function() {
				WORLD.play_sound(self.states.wall_jump.sound);
				self.input.__useBuffer = false;
				self.timer = CURRENT_FRAME;
				self.publish("animation_play", { name: "wall_jump" });
				self.dir = self.get_wall_jump_dir();
				if (self.dir != 0) self.publish("animation_xscale", self.dir)
				self.physics.set_speed(0, 0);
				self.states.dash_air.curr_dashes = 0;
				double_jumps = self.states.jump.count - 1;
				self.physics.set_grav(new Vec2(0,0));
				
				PROJECTILES.create_projectile(self.get_instance().x, self.get_instance().y, self.dir, XIcarusArmorHeadbuttProjectile, get(ComponentWeaponUse), ["player"], 0);
					
			},
			leave: function() {	
				self.physics.update_gravity();
			},
			step: function() {
				if (self.timer + self.states.wall_jump.launch_lock < CURRENT_FRAME){
					self.set_hor_movement();	
				} else if (self.timer + self.states.wall_jump.launch_lock == CURRENT_FRAME){
					self.input.__useBuffer = true;
					self.publish("animation_play", { name: "jump", frame: 15, reset: false});
					self.set_hor_movement();
				}
				
				if (self.timer + self.states.wall_jump.wall_stick == CURRENT_FRAME) {
					self.physics.update_gravity();
					
					var _inst = self.get_instance();
					
					if (self.input.get_input("dash") && self.fsm.state_exists("dash") && global.settings.extra_particles) {
						WORLD.spawn_particle(new DashUpParticle(_inst.x, _inst.y + 16, self.dir))
					} else {
						WORLD.spawn_particle(new SparkParticle(_inst.x + 24 * self.dir, _inst.y + 16, self.dir))
					}
					
					if (self.input.get_input("dash") && self.fsm.state_exists("dash")) {
						self.current_hspd = self.states.dash.speed;	
						if (!self.physics.is_on_ceil() || self.dir != self.hdir)
							self.physics.set_hspd(self.states.dash.speed * self.dir * -1)
						self.dash_jump = true;
					} else {
						if (!self.physics.is_on_ceil() || self.dir != self.hdir)
							self.physics.set_hspd(self.states.walk.speed * self.dir * -1)
					}
					self.physics.set_vspd(-self.states.wall_jump.strength);	
				}
			}
		})
		}
		set_default_palette(_player, [ #f04010, #903010, #502008, #f04010, #903010, #502008, #f0f0f0, #989898, #707070, #f8b878, #f04010]);
	}
	self.set_bonus = IcarusArmorSetBonus;
	self.description = "Creates a damaging aura when jumping."
}

function XIcarusArmorBoot() : X8BootBase() constructor{
	self.armor_name = "Icarus Boots";
	self.apply_armor_effects = function(_player){
		_player.states.jump.strength *= 1.5;
		_player.states.wall_jump.strength *= 1.5;
		
		set_default_palette(_player,[ #f04010, #903010, #502008, #f04010, #903010, #502008, #f0f0f0, #989898, #707070, #f8b878, #f04010]);
	}
	self.set_bonus = IcarusArmorSetBonus;
	self.description = "Doubles jump height."
}

function XIcarusArmorBody() : X8BodyBase() constructor{
	self.armor_name = "Icarus Body";
	self.damage_rate = 0.5;
	self.apply_armor_effects = function(_player){
		_player.get(ComponentDamageable).red_health_active = true;
		_player.get(ComponentDamageable).red_hp_is_additive = true;
		_player.get(ComponentDamageable).red_health_percentage = 1;
		_player.get(ComponentDamageable).invuln_time *= 0.7
		_player.get(ComponentDamageable).super_armor = true;
		set_default_palette(_player, [ #f04010, #903010, #502008, #f04010, #903010, #502008, #f0f0f0, #989898, #707070, #f8b878, #f04010]);
	}
	self.set_bonus = IcarusArmorSetBonus;
	self.description = "Taken damage is converted into red health, which heals slowly over time. Red health is lost upon being hit."
}

function XIcarusArmorHeadbuttProjectile() : ProjectileData() constructor{
	self.comboiness = -1;
	self.damage = 3;
	self.shot_limit = 3;
	self.animation = "icarus_headbutt"
	
	self.hitbox_scale = new Vec2(32,64);
	self.hitbox_offset = new Vec2(0,0);
	
	self.create = function(_inst){
	}
	
	self.step = function(_inst){
		//
		
		var _player = instance_nearest(_inst.x, _inst.y, obj_player)
		
		_inst.x = _player.x;
		_inst.y = _player.y;
		
		self.dir = (CURRENT_FRAME mod 2)
		
		if(_player.components.get(ComponentPhysics).get_vspd() > 0 || _player.components.get(ComponentPhysics).is_on_floor()){
			PROJECTILES.destroy_projectile(self);
		}
	}
	self.destroy = function(_inst){
		log("FALL")
	}
}

function IcarusArmorSetBonus( _player, _palette = [ #f8b878, #f04010, #903010, #f8b878, #f04010, #903010, #f0f0f0, #989898, #707070, #f8d8a8, #f8b878]){
	//log(_player.get(ComponentArmorHandler).armor_parts)
	if _palette[0] = #f8b878 {
		var _weps = _player.get(ComponentWeaponUse)
		array_push(_weps.weapon_list, IcarusCrush)
		_player.get(ComponentWeaponUse).set_weapons(_player.get(ComponentWeaponUse).weapon_list)
		_player.get(ComponentWeaponUse).weapon_selection[3]++;
	}
	
	for(var r = 0; r < array_length(_player.get(ComponentArmorHandler).armor_parts[0]); r++){
		var _armor = _player.get(ComponentArmorHandler).armor_parts[0][r]
		_armor.palette = _palette
		log(_armor.part_palette)
		
	}
}