function RockCharacter() : BaseCharacter() constructor{
	self.image_folder = "megaman";
	self.init = function(_player){
		self.init_default(_player);
		add_dash(_player);
		add_wall_jump(_player);
	}
	self.states.dash.animation = "slide"
}