function IcarusCrush() : ProjectileWeapon() constructor{
	self.data = [IcarusCrushHandler];
	self.charge_limit = 0;
	self.refillRate = 1/30
	self.cost = 0;
	self.giga = true;
	self.not_selectable = true;
	self.title = "GAEA CRUSH";
	self.description = "LARGE RELEASE OF ABSORBED DAMAGE"
	
	self.weapon_palette = global.player_character[global.local_player_index].default_palette;
}

function IcarusCrushHandler() : StateBasedData() constructor{
	self.state_name = "Icarus Crush"
	
	self.init = function(_player){
		with(_player){
			fsm.add(other.state_name,{
				enter: function() {
					self.physics.set_grav(new Vec2(0,0));
					self.timer = CURRENT_FRAME + 45;
					self.physics.set_speed(0, 0);
					self.publish("animation_play", { name: "giga_crush" });
				},
				step: function() {
					if(timer == CURRENT_FRAME){
						var _crush = PROJECTILES.create_projectile(get_instance().x, get_instance().y, dir, IcarusCrushProjectile, get(ComponentWeaponUse), ["player"], 0);
						var _player = instance_nearest(0,0,obj_player);
						_crush.scale = _player.components.get(ComponentWeaponUse).weapon_ammo[_player.components.get(ComponentWeaponUse).giga_index]
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

function IcarusCrushProjectile() : ProjectileData() constructor{
	//self.animation_append = "_shoot";
	self.shot_limit = 1;
	self.comboiness = 1;//one full volley of lemons
	self.damage = 0;
	self.start_time = CURRENT_FRAME
	self.scale = 1;
	self.animation = "rolling_shield"
	
	self.hitbox_scale = new Vec2(32,32);
	self.hitbox_offset = new Vec2(0,0);
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_1");
	}
	self.step = function(_inst){
		
		self.dir = self.scale;
		self.vdir = self.scale;
		
		if(self.start_time + 3 == CURRENT_FRAME)
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
	}
	self.destroy = function(_inst){
	}
}