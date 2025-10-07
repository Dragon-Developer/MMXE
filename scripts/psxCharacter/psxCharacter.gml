function psxCharacter() : BaseCharacter() constructor{
	
	self.image_folder = "psx";
	
	self.states.dash.speed = 4.125;
	self.states.walk.speed = 2;
	self.states.jump.speed = 5.5546875;
	
	self.weapons = [xBuster, SpinningWheel, SecondArmorRadar, XenoMissile];
	
	self.default_palette = [
		#2040a8,//Blue Armor Bits
		#3068c8,
		#3880d8,
		#204860,//Under Armor Teal Bits
		#188868,
		#30c0a0,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	
	self.init = function(_player){
		
		self.init_default(_player);
		with(_player){
			get_instance().mask_index = spr_psx_mask;
			add_dash();
			add_wall_jump();
		}
	}
}