function RockCharacter() : BaseCharacter() constructor{
	self.image_folder = "megaman";
	self.init = function(_player){
		self.init_default(_player);
		with(_player){
			add_dash();
			add_wall_jump();
		}
	}
	self.states.dash.animation = "slide"
}