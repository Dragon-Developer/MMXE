function WaveBurner() : FireWave() constructor{
	self.data = [WaveBurnerData, WaveBurnerData, WaveBurnerData];
	self.charge_limit = 0;
	
	if(global.character_ref[global.character_index] == BassCharacter){
		self.weapon_palette = [
			#905800,//Blue Armor Bits
			#48c890,
			#78e0c8,
			#185830,//Under Armor Teal Bits
			#306810,
			#60b828
		];
	} else {
		self.weapon_palette = [
			#800030,//Blue Armor Bits
			#b00040,
			#e80058,
			#a85030,//Under Armor Teal Bits
			#d07040,
			#f0a070
		];
	}
	
	self.title = "WAVE B.";
}

function WaveBurnerData() : FireWaveData() constructor{
	//the lemon
	self.comboiness = 1;//one full volley of lemons
	
	self.shot_limit = 20;
	self.shot_delay = 3;
	self.damage = 0.5;
	self.boss_damage = 2;
	self.animation = "wave_burner";
	self.init_time = CURRENT_FRAME;
	
	self.create = function(_inst){
		WORLD.play_sound("fire_wave");
	}
	self.step = function(_inst){
		var _hspd = 4 + abs(cos(init_time / 10));
		_inst.x += _hspd * self.dir;
		_inst.y += sin(init_time / 10) * 2
			
		if(CURRENT_FRAME > init_time + 12)
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new FireWaveDieParticle(_inst.x, _inst.y, dir))
	}
}