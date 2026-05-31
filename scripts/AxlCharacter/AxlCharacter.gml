function AxlCharacter() : BaseCharacter() constructor{
	self.image_folder = "axl";
	self.states.intro.animation = "intro"
	self.weapons = [AxlBullets];
	
	self.states.dash.speed = 4;
	self.states.dash.interval *= 1.5;
	
	self.zipline_palette = [
		#908800,//Blue Armor Bits
		#d8c840,
		#fff860,
	]
	
	self.init = function(_player){
		self.init_default(_player);
		add_dash(_player);
		add_air_dash(_player, self)
		add_wall_jump(_player);
		add_zipline(_player)
	}
}