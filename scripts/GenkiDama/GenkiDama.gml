function GenkiDama() : ProjectileWeapon() constructor{
	self.data = [GenkiDamaHandler];
	self.charge_limit = 0;
	self.cost = 7;
	self.not_selectable = true;
	self.giga = true;
	self.title = "GAEA CRUSH";
	self.description = "LARGE RELEASE OF ABSORBED DAMAGE"
	
	self.weapon_palette = global.player_character[global.local_player_index].default_palette;
}

function GenkiDamaHandler() : StateBasedData() constructor{
	self.state_name = "Genki Dama"
	
	self.init = function(_player){
		with(_player){
			fsm.add(other.state_name,{
				enter: function() {
					self.physics.set_grav(new Vec2(0,0));
					self.timer = CURRENT_FRAME + 45;
					self.physics.set_speed(0, 0);
					self.publish("animation_play", { name: "genki_dama" });
				},
				step: function() {
					if(timer == CURRENT_FRAME){
						PROJECTILES.create_projectile(get_instance().x, get_instance().y, dir, GenkiDamaData, get(ComponentWeaponUse), ["player"], 0);
					}
				},
				leave: function() {
					self.physics.set_grav(self.physics.grav_default);
				}
			})
			.add_transition("t_animation_end", other.state_name, "fall", function(){return !self.input.get_input("jump")})
			.add_transition("t_animation_end", other.state_name, "jump", function(){return self.input.get_input("jump")})
		}
	}
}

function GenkiDamaData() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 1;//one full volley of lemons
	
	self.shot_limit = 3;
	self.animation = "genki_dama";
	self.start_time = CURRENT_FRAME;
	self.hitbox_scale = new Vec2(80,64);
	self.hitbox_offset = new Vec2(0,0);
	self.invuln_rate = 0.1;
	self.piercing = true;
	self.super_piercing = true;
	
	self.create = function(_inst){
		//log(init_time)
		//may make this default
		WORLD.play_sound("shoot_1");
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 6;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 2;
		if(!is_undefined(_inst))
			_inst.x += _hspd * self.dir;
			
		if(self.start_time + 110 == CURRENT_FRAME)
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}