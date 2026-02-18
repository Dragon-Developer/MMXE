// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function CustomCharacter() : BaseCharacter() constructor{
	self.image_folder = "custom";
	self.default_health = 8;
	
	external_data = JSON.load(working_directory + "sprites/custom/data.json")
	
	self.states.walk.speed            = external_data.walk_speed;
	self.states.dash.speed            = external_data.dash_speed;
	self.states.dash.dash_interval    = external_data.dash_interval;
	self.states.jump.strength         = external_data.jump_strength;
	self.states.wall_jump.strength    = external_data.wall_jump_strength;
	self.states.wall_jump.stick       = external_data.wall_jump_stick;
	self.states.wall_jump.launch_lock = external_data.wall_jump_launch_lock;
	
	self.init = function(_player){
		log(external_data);
		self.init_default(_player);
		if(external_data.can_dash)
		with(_player){
			add_dash();
		}
		if(external_data.can_wall_slide)
		with(_player){
			add_wall_jump();
		}
	}
}