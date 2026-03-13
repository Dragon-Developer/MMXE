// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function RollingShield() : ProjectileWeapon() constructor{
	self.data = [RollingShieldData,RollingShieldData,RollingShieldData,RollingShieldChargedData,RollingShieldChargedData];
	self.charge_limit = 4;
	self.weapon_palette = [
		#d62142,//Blue Armor Bits
		#d74263,
		#f7849c,
		#84ad8c,//Under Armor Teal Bits
		#a5c6ad,
		#ceefd6
	];
	self.title = "R. SHIELD";
}

function RollingShieldData() : ProjectileData() constructor{
	
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 2;
	self.damage = 2;
	self.bounces = 6;
	self.hitbox_scale = new Vec2(32,32);
	self.animation = "rolling_shield";
	
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
			if(bounces-- > 1){
				self.dir *= -1;
				comboiness++;
				return;
			}
			
			WORLD.play_sound("freeze");
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
		}
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function RollingShieldChargedData() : ProjectileData() constructor{
	
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 1;
	self.damage = 2;
	self.bounces = 6;
	self.hitbox_scale = new Vec2(48,48);
	self.animation = "rolling_shield_charged";
	
	self.create = function(_inst){
		//log(init_time)
		//may make this default
		WORLD.play_sound("shoot_1");
	}
	self.step = function(_inst){
		
		var _plr = instance_nearest(_inst.x, _inst.y, obj_player);
		_inst.x = _plr.x;
		_inst.y = _plr.y;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}