function RockCharacter() : BaseCharacter() constructor{
	self.image_folder = "megaman";
	
	self.weapons = [xBuster, BassBuster, FireWave, ElectricWeb, ShotgunIce, WaveBurner];
	
	self.default_score = 1500;//way the fuck higher because rock doesnt have armors
	self.init = function(_player){
		self.init_default(_player);
		add_slide(_player, self);
		add_wall_jump(_player);
	}
	self.states.dash.animation = "slide"
	
	self.default_palette = [
		#203080,//Blue Armor Bits
		#0040f0,
		#0080f8,
		#0f4eaa,//Under Armor Teal Bits
		#52a0ef,
		#78d8f1,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
}