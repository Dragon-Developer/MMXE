function AxlCharacter() : BaseCharacter() constructor{
	self.image_folder = "axl";
	self.states.intro.animation = "intro"
	self.weapons = [AxlBullets];
	
	self.states.dash.speed = 4;
	
	self.init = function(_player){
		self.init_default(_player);
		add_dash(_player);
		add_wall_jump(_player);
	}
}