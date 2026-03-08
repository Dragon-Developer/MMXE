function ShotgunIce() : ProjectileWeapon() constructor{
	self.data = [ShotgunIceData,ShotgunIceData,ShotgunIceData,ShotgunIceSled,ShotgunIceSled];
	self.charge_limit = 4;
	self.weapon_palette = [
		#3973f7,//Blue Armor Bits
		#529cef,
		#39e7ff,
		#ad6b21,//Under Armor Teal Bits
		#efad31,
		#ffe752
	];
	self.title = "S. ICE";
}

function ShotgunIceData() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 2;
	self.damage = 2;
	self.animation = "shotgun_ice";
	
	self.create = function(_inst){
		//log(init_time)
		//may make this default
		WORLD.play_sound("shoot_1");
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else if (CURRENT_FRAME - self.init_time > 24)_hspd = 6.25;
		if(!is_undefined(_inst))
			_inst.x += _hspd * self.dir;
			
		if(instance_position(_inst.x + 10 * dir, _inst.y, obj_square_16)){
			PROJECTILES.create_projectile(_inst.x, _inst.y, dir * -1, ShotgunIceFragmentData, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			PROJECTILES.create_projectile(_inst.x, _inst.y, dir * -1, ShotgunIceFragment2Data, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			PROJECTILES.create_projectile(_inst.x, _inst.y, dir * -1, ShotgunIceFragment3Data, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			PROJECTILES.create_projectile(_inst.x, _inst.y, dir * -1, ShotgunIceFragment4Data, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
			PROJECTILES.create_projectile(_inst.x, _inst.y, dir * -1, ShotgunIceFragment5Data, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
				
			WORLD.play_sound("freeze");
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
		}
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function ShotgunIceFragmentData() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 1;//one full volley of lemons
	
	self.shot_limit = 2;
	self.damage = 2;
	self.animation = "shotgun_ice_fragment";
	self.vspd = 0;
	self.hspd = 8;
	
	self.create = function(_inst){}
	self.step = function(_inst){
		_inst.x += hspd * self.dir;
		_inst.y += vspd;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function ShotgunIceFragment2Data() : ShotgunIceFragmentData() constructor{
	self.comboiness = 2;
	self.vspd = 5;
	self.hspd = 7;
}

function ShotgunIceFragment3Data() : ShotgunIceFragmentData() constructor{
	self.comboiness = 3;
	self.vspd = -5;
	self.hspd = 7;
}

function ShotgunIceFragment4Data() : ShotgunIceFragmentData() constructor{
	self.comboiness = 4;
	self.vspd = 7;
	self.hspd = 5;
}

function ShotgunIceFragment5Data() : ShotgunIceFragmentData() constructor{
	self.comboiness = 5;
	self.vspd = -7;
	self.hspd = 5;
}

function ShotgunIceSled() : ProjectileData() constructor{
	self.comboiness = 7;
	
	self.shot_limit = 80;
	self.damage = 5;
	self.animation = "shotgun_ice_sled";
	self.collision = undefined;
	self.start_time = CURRENT_FRAME;
	self.grav = 0.25;
	self.vspd = 0;
	self.reset_cam = false;
	
	self.create = function(_inst){
		collision = instance_create_depth(floor(_inst.x) - 2 + ((dir - 1) / 2) * 28, floor(_inst.y) - 8, 0, obj_square_16)
		
		collision.image_xscale = 2;
		collision.image_yscale = 0.825;
		
		WORLD.play_sound("shoot_1");
		
		var _cam = instance_nearest(0,0,obj_camera);
		_cam.components.get(ComponentCamera).movement_limit_x *= 3;
	}
	self.step = function(_inst){
		//movement code go here
		
		if(CURRENT_FRAME - start_time < 20 || !instance_exists(collision)) return;
		
		if(instance_position(_inst.x, _inst.y + 8, obj_square_16)){
			while(instance_position(_inst.x, _inst.y + 7, obj_square_16) && instance_position(_inst.x, _inst.y + 8, obj_square_16) != collision){
				_inst.y--;
				collision.y--;
			}
			vspd = 0;
		} else {
			vspd = clamp(vspd + grav, 0, 3);
			_inst.y += vspd;
		}
		
		if(CURRENT_FRAME - start_time > 60){
			if(instance_position(_inst.x + 32 * dir, _inst.y, obj_square_16)){
				PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
			} else {
				var _spd = min((CURRENT_FRAME - start_time) / 60, 9) * dir
				_inst.x += _spd
				var _move_player = undefined;
				
				if(instance_position(_inst.x - 4 * dir, _inst.y - 14, obj_player)){
					_move_player = instance_position(_inst.x -4 * dir, _inst.y - 14, obj_player)
				} else if(instance_position(_inst.x + 11 * dir, _inst.y - 14, obj_player)){
					_move_player = instance_position(_inst.x + 11 * dir, _inst.y - 14, obj_player)
				} else if(instance_position(_inst.x + 25 * dir, _inst.y - 14, obj_player)){
					_move_player = instance_position(_inst.x + 25 * dir, _inst.y - 14, obj_player)
				}
				
				if(_move_player){
					_move_player.x += _spd
					_move_player.y += vspd
				}
				
			}
		}
		
		if(!instance_exists(collision)) return;
		
		collision.x = floor(_inst.x) - 2 + ((dir - 1) / 2) * 28;
		collision.y = floor(_inst.y) - 8;
	}
	self.destroy = function(_inst){
		instance_destroy(collision)
		
		
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
		
		if(!reset_cam){
			reset_cam = true;
			var _cam = instance_nearest(0,0,obj_camera);
			_cam.components.get(ComponentCamera).movement_limit_x /= 3;	
		}
	}
}