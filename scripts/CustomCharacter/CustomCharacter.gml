// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function CustomCharacter() : BaseCharacter() constructor{
	self.image_folder = "custom";
	self.default_health = 8;
	
	self.init = function(_player){
		self.init_default(_player);
		with(_player){
			add_dash();
			add_wall_jump();
		}
	}
}