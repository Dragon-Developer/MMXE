function ZeroCharacter() : BaseCharacter() constructor{
	self.image_folder = "zero";
	self.weapons = [xBuster, XenoMissile];
	self.init = function(_player){
		self.init_default(_player);
		with(_player){
			add_dash();
			add_wall_jump();
		}
	}
}