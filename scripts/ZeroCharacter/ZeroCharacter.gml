function ZeroCharacter() : BaseCharacter() constructor{
	self.image_folder = "zero";
	self.weapons = [xBuster, XenoMissile];
	
	self.states.wall_jump.wall_stick = 0;
	self.states.wall_jump.launch_lock = 6;
	
	self.init = function(_player){
		self.init_default(_player);
		with(_player){
			add_dash();
			add_wall_jump();
		}
	}
}