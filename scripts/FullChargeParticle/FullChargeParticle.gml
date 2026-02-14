function FullChargeParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "lime_die";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 3;
	self.frame = 0;
	self.dir = _dir;
	self.depth = -1700;
}