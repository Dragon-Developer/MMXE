// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function BassBuster() : xBuster() constructor{
	self.data = [BassBuster1Data,BassBuster2Data,BassBuster3Data,BassBuster3Data,BassBuster3Data];

	self.title = "B. BUSTER";
	self.description = "Evil Mega Buster Variant"
	
	self.weapon_palette = [
		#b10000,//eye
		#0f4eaa,//gems
		#52a0ef,
		#682c1d,//oranges
		#c93800,
		#f9a928
	];
}

function BassBuster1Data() : xBuster11Data() constructor{
	self.animation = "bass_shot_0";
	self.create = function(_inst){
		WORLD.play_sound("shoot_1");
		WORLD.spawn_particle(new BassLemonFireParticle(_inst.x, _inst.y, 1))
	}
}

function BassBuster2Data() : xBuster12Data() constructor{
	self.animation = "bass_shot_1";
	self.create = function(_inst){
		WORLD.play_sound("shoot_2");
		WORLD.spawn_particle(new BassLimeFireParticle(_inst.x, _inst.y, 1))
	}
}

function BassBuster3Data() : xBuster13Data() constructor{
	self.animation = "bass_shot_2";
	self.create = function(_inst){
		WORLD.play_sound("shoot_3");
		WORLD.spawn_particle(new BassFullShotFireParticle(_inst.x, _inst.y, 1))
	}
}

function BassLemonFireParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "bass_shot_0";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 4;
	self.frame = 0;
	self.frame_max = 3;
	self.dir = _dir;
}

function BassLimeFireParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "bass_shot_1";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 4;
	self.frame = 0;
	self.frame_max = 2;
	self.dir = _dir;
}

function BassFullShotFireParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "bass_shot_2";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 4;
	self.frame = 0;
	self.frame_max = 3;
	self.dir = _dir;
}