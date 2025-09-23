function DashParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = spr_player_dash_spark;
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 1;
	self.frame = 0;
	self.dir = _dir;
}

function DustParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = spr_player_dash_dust;
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 5;
	self.frame = 0;
	self.dir = _dir;
}

function DashUpParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = spr_player_dash_up_spark;
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 1;
	self.frame = 0;
	self.dir = _dir;
}

function DashDownParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = spr_player_dash_up_spark;
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y - 16);
	self.time = 0;
	self.time_max = 1;
	self.frame = 0;
	self.dir = _dir;
	self.vdir = -1;
}

function ExplosionParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = spr_explosion;
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 3;
	self.frame = 0;
	self.dir = _dir;
}

function SparkParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = spr_player_wall_jump_spark;
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 3;
	self.frame = 0;
	self.dir = _dir;
}