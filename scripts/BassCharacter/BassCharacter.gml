function BassCharacter() : BaseCharacter() constructor{
	self.image_folder = "bass";
	self.init = function(_player){
		self.init_default(_player);
		add_dash(_player);
		add_wall_jump(_player);
	}
}