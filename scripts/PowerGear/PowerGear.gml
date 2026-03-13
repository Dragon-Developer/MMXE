// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PowerGear() : ProjectileWeapon() constructor{
	self.data = [PowerGearHandler];
	self.charge_limit = 0;
	self.cost = 0;
	self.animation_append = "";
	self.not_selectable = true;
	self.title = "POWER GEAR";
	self.description = "Increased lethality of weapons"
	
	self.weapon_palette = global.player_character[global.local_player_index].default_palette;
}

function PowerGearHandler() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.damage = 0;
	self.shot_limit = 999;
	self.animation = "deezNuts";
	self.spawn_time = CURRENT_FRAME;
	self.animation_append = "";
	
	self.create = function(_inst){
		log(shooter.get(ComponentWeaponUse).supercharged)
		
		if(shooter.get(ComponentWeaponUse).supercharged || instance_nearest(0,0,obj_double_gear_handler).components.get(ComponentDoubleGearHandler).tired) {
			self.destroy();
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
			return;
		} else {
			log("worked")
			shooter.get(ComponentWeaponUse).supercharged = true
			shooter.projectile_count--;
			
			with(obj_double_gear_handler){
				components.get(ComponentDoubleGearHandler).start_gear("power")
			}
			
			WORLD.spawn_particle(new PowerGearParticle(shooter.get_instance().x, shooter.get_instance().y, 1))
		}
	}
	self.step = function(_inst){
		with(obj_double_gear_handler){
			if(!components.get(ComponentDoubleGearHandler).active || components.get(ComponentDoubleGearHandler).gear == "speed" || !other.shooter.get(ComponentWeaponUse).supercharged){
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
		shooter.get(ComponentWeaponUse).supercharged = false;
		log("FALL")
		
		
		
		with(obj_double_gear_handler){
			components.get(ComponentDoubleGearHandler).stop_gear("power")
		}
	}
}

function PowerGearParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "power_gear";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 3;
	self.frame = 0;
	self.frame_max = 10;
	self.dir = _dir;
}