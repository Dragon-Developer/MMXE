function AxlCharacter() : BaseCharacter() constructor{
	self.image_folder = "axl";
	self.states.intro.animation = "intro"
	self.weapons = [AxlBullets];
	
	self.init = function(_player){
		self.init_default(_player);
		with(_player){
			add_dash();
			add_wall_jump();
		}
	}
}