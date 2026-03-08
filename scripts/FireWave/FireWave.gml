function FireWave() : FlamethrowerWeapon() constructor{
	self.data = [FireWaveData, FireWaveData, FireWaveData, FireWaveTempFullCharge];
	self.charge_limit = 3;
	self.cost = 0.1;
	
	self.weapon_palette = [
		#731808,//Blue Armor Bits
		#bd2110,
		#f72110,
		#bd5221,//Under Armor Teal Bits
		#f7a542,
		#ffde8c
	];
	
	self.title = "FIRE WAVE";
}

function FireWaveData() : FlamethrowerData() constructor{
	//the lemon
	self.comboiness = 1;//one full volley of lemons
	
	self.shot_limit = 20;
	self.shot_delay = 3;
	self.damage = 0.5;
	self.boss_damage = 2;
	self.animation = "fire_wave";
	self.init_time = CURRENT_FRAME;
	
	self.create = function(_inst){
		WORLD.play_sound("fire_wave");
	}
	self.step = function(_inst){
		var _hspd = 5;
			_inst.x += _hspd * self.dir;
			
			if(CURRENT_FRAME > init_time + 10)
				PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new FireWaveDieParticle(_inst.x, _inst.y, dir))
	}
}

function FireWaveDieParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "fire_wave_die";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(_dir,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 4;
	self.frame = 0;
	self.frame_max = 3;
	self.dir = _dir;
}

function FireWaveTempFullCharge() : xBuster13Data() constructor{
	self.comboiness = 5;
	self.damage = 8;
	self.shot_limit = 100;
	self.piercing = true;
	
	self.animation = "fire_wave_temp_full_charge";
	
	self.create = function(_inst){
		WORLD.play_sound("fire_wave");
		WORLD.play_sound("shoot_2");
	}
}