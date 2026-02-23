// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function RockBreakParticle(_x, _y, _seed = 0) : ParticleBase() constructor{
	self.sprite = "rock_break";
	self.death_mode = "duration_frame";
	self.position = new Vec2(_x,_y);
	self.velocity = new Vec2(sin(CURRENT_FRAME + _seed) * 2,sin((CURRENT_FRAME + _seed) * 1.1) * 2 - 1);
	self.acceleration = new Vec2(0,0.1);
	self.time_max = 32;
	self.frame_max = 4;
}