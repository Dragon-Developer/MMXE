function ZeroCharacter() : BaseCharacter() constructor{
	self.image_folder = "zero";
	self.weapons = [ZeroSaber];
	self.default_score = 1200;//slightly higher because he's worse at bosses
	
	self.possible_armors = [
		[noone],//heads
		[noone],//arms
		[noone],//bodies
		[noone],//boots
		[noone, BlackZero, X1Zero]//full set
	];
	
	self.zipline_palette = [
		#6b3110,//Blue Armor Bits
		#ad3008,
		#f75108,
	]
	
	default_palette = [
		#6b3110,//Blue Armor Bits
		#ad3008,
		#f75108,
		#185ab5,//Under Armor Teal Bits
		#6bb5f7,
		#efffff,
		#392929,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	
	self.states.intro.animation = "intro"
	self.states.jump.double_jump_animation = "double_jump"
	self.states.wall_jump.wall_stick = 0;
	self.states.wall_jump.launch_lock = 6;
	self.states.jump.count = 2;
	self.boss_music = "ZeroCrashL"
	
	self.init = function(_player){
		self.init_default(_player);
		add_dash(_player);
		add_wall_jump(_player);
		add_air_dash(_player)
		add_zipline(_player)
	}
}