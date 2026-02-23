function ZeroCharacter() : BaseCharacter() constructor{
	self.image_folder = "zero";
	self.weapons = [ZeroSaber];
	
	self.possible_armors = [
		[noone],//heads
		[noone],//arms
		[noone],//bodies
		[noone],//boots
		[noone, BlackZero]//full set
	];
	
	self.states.intro.animation = "intro"
	self.states.wall_jump.wall_stick = 0;
	self.states.wall_jump.launch_lock = 6;
	self.states.jump.count = 2;
	
	self.init = function(_player){
		self.init_default(_player);
		add_dash(_player);
		add_wall_jump(_player);
	}
}