function SpeedGear() : ProjectileWeapon() constructor{
	self.data = [SpeedGearHandler];
	self.charge_limit = 0;
	self.cost = 0;
	self.not_selectable = true;
	self.animation_append = "";
	self.title = "SPEED GEAR";
	self.description = "Slows down percieved time"
	
	self.weapon_palette = global.player_character[global.local_player_index].default_palette;
}

function SpeedGearHandler() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.damage = 0;
	self.shot_limit = 999;
	self.animation = "deezNuts";
	self.spawn_time = CURRENT_FRAME;
	self.animation_append = "";
	
	self.create = function(_inst){
		log(global.game.game_loop.game_speed)
		
		if(global.game.game_loop.game_speed != 1 || instance_nearest(0,0,obj_double_gear_handler).components.get(ComponentDoubleGearHandler).tired) {
			self.destroy();
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
			
			log("FALL")
			return;
		} else {
			log("worked")
			global.game.game_loop.game_speed = 1/3;
			self.spawn_time = CURRENT_FRAME;
			with(obj_entity){
				if(variable_struct_exists(components, "change_timescale"))
					components.change_timescale(1/3);
			}
			shooter.get_instance().components.change_timescale(1/2);
			shooter.projectile_count--;
			
			with(obj_double_gear_handler){
				components.get(ComponentDoubleGearHandler).start_gear("speed")
				
				
			}
			WORLD.components.get(ComponentSoundLoader).set_sound_pitch(1/3)
			
			WORLD.spawn_particle(new SpeedGearParticle(shooter.get_instance().x, shooter.get_instance().y, 1))
		}
	}
	self.step = function(_inst){
		with(obj_double_gear_handler){
			if(!components.get(ComponentDoubleGearHandler).active || components.get(ComponentDoubleGearHandler).gear == "power" || global.game.game_loop.game_speed == 1){
				other.destroy();
				PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(other)
			}
		}
		
		_inst.x = shooter.get_instance().x;
		_inst.y = shooter.get_instance().y;
	}
	self.draw_gui = function(){
		draw_sprite_ext(spr_bright, 0, 0, 0, 1, 1, 0, c_black, clamp((CURRENT_FRAME - self.spawn_time) / 40, 0, 0.2));
	}
	self.destroy = function(_inst){
		global.game.game_loop.game_speed = 1;
		WORLD.components.get(ComponentSoundLoader).set_sound_pitch(1)
		with(obj_entity){
			if(variable_struct_exists(components, "change_timescale"))
				components.change_timescale(1);
			if(components.get(ComponentPhysics))
				if(variable_struct_exists(components.get(ComponentPhysics), "time_physics_multiplier"))
					components.get(ComponentPhysics).time_physics_multiplier = 1;
		}
		shooter.get_instance().components.change_timescale(1);
		
		
		with(obj_double_gear_handler){
			components.get(ComponentDoubleGearHandler).stop_gear("speed")
		}
		
	}
}

function SpeedGearParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "speed_gear";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 1;
	self.frame = 0;
	self.frame_max = 10;
	self.dir = _dir;
}