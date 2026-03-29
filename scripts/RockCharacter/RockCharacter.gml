function RockCharacter() : BaseCharacter() constructor{
	self.image_folder = "megaman";
	
	self.weapons = [RockBuster, FireWave, ElectricWeb, ShotgunIce, WaveBurner, RollingShield, MetalAnchor, TwinSlasher, GroundHunter]
	
	self.default_score = 1500;//way the fuck higher because rock doesnt have armors
	self.init = function(_player){
		self.init_default(_player);
		add_slide(_player, self);
		add_wall_jump(_player);
	}
	self.states.dash.animation = "slide"
	
	self.possible_armors = [
		[noone],//heads
		[noone],//arms
		[noone],//bodies
		[noone],//boots
		[ArmorDoubleGear]//full set
	];
	self.default_palette = [
		#203080,//Blue Armor Bits
		#0040f0,
		#0080f8,
		#0f4eaa,//Under Armor Teal Bits
		#52a0ef,
		#78d8f1,
		#202020,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	
	self.charge_colors = [
		[
			#503068,//Blue Armor Bits
			#5840d0,
			#9880f0,
			#6090a8,//Under Armor Teal Bits
			#78c0d8,
			#b8d8f8,
			#1852e7,//black
			#482878,//Face
			#b86048,
			#f8b080,
			#989898,//glove
			#e0e0e0,
			#f0f0f0,//eye white
			#f76bc6//red
		],
		[
			#00a880,//Blue Armor Bits
			#00d090,
			#a8f8e0,
			#60b0d8,//Under Armor Teal Bits
			#78d0f0,
			#d8f8f8,
			#007850,//black
			#804020,//Face
			#b86048,
			#f8b080,
			#989898,//glove
			#e0e0e0,
			#f0f0f0,//eye white
			#f76bc6//red
		],
		[
			#8c73ef,//Blue Armor Bits
			#b58cff,
			#b5adff,
			#9c8cf7,//Under Armor Teal Bits
			#ceb5ff,
			#e7e7ff,
			#9400de,//black
			#804020,//Face
			#b86048,
			#f8b080,
			#989898,//glove
			#e0e0e0,
			#f0f0f0,//eye white
			#f76bc6//red
		],
		[
			#e74a21,//Blue Armor Bits
			#e78c29,
			#ffad29,
			#e78c29,//Under Armor Teal Bits
			#f7a57b,
			#ffd69c,
			#8c0000,//black
			#804020,//Face
			#b86048,
			#f8b080,
			#f7a57b,//glove
			#ffd69c,
			#f0f0f0,//eye white
			#f76bc6//red
		]
	]
}