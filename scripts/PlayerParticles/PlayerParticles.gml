function DashParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "dash_spark";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 1;
	self.frame = 0;
	self.frame_max = 6;
	self.dir = _dir;
}

function DustParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "dash_dust";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 5;
	self.frame = 0;
	self.frame_max = 6;
	self.dir = _dir;
}

function DashUpParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "dash_up_spark";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 1;
	self.frame = 0;
	self.frame_max = 11;
	self.dir = _dir;
}

function DashDownParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "dash_up_spark";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y - 16);
	self.time = 0;
	self.time_max = 1;
	self.frame = 0;
	self.frame_max = 11;
	self.dir = _dir;
	self.vdir = -1;
}

function ExplosionParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "explosion";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 3;
	self.frame = 0;
	self.frame_max = 8;
	self.dir = _dir;
}

function SparkParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "lemon_die";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 2;
	self.frame = 0;
	self.dir = _dir;
}

function DeathBubbleParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "death";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(random_range(-5,5),random_range(-5,5));
	
	self.velocity = velocity.normalize();
	self.velocity = velocity.multiply(10);
	
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 32;
	self.frame = 0;
	self.frame_max = 6;
	self.dir = _dir;
}

function LimeDieParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "lime_die";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 2;
	self.frame = 0;
	self.frame_max = 5;
	self.dir = _dir;
}

function CompleteParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "complete";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 2;
	self.frame = 0;
	self.frame_max = 5;
	self.dir = _dir;
}