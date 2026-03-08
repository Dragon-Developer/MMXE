function BassCharacter() : BaseCharacter() constructor{
	self.image_folder = "bass";
	
	self.weapons = [BassBuster, FireWave, ElectricWeb, ShotgunIce, WaveBurner]
	
	self.default_score = 1100;//double jump is real strong he aint getting any leeway
	self.states.jump.count = 2;
	self.init = function(_player){
		self.init_default(_player);
		_player.get(ComponentWeaponUse).weapon_use_rate = 0.75;
		add_dash(_player);
		add_wall_jump(_player);
	}
	
	self.default_palette = [
		#b10000,//eye
		#0f4eaa,//gems
		#52a0ef,
		#682c1d,//oranges
		#c93800,
		#f9a928,
		#202020,//black
		#2b1e24,//greys
		#383038,
		#505058,
		#788199,
		#b1b9c1
	];
	
	self.charge_colors = [
		[
			#b10000,//eye
			#b05000,//gems
			#f8a000,
			#6090a8,//oranges
			#78c0d8,
			#b8d8f8,
			#482878,//black
			#503068,//greys
			#5840d0,
			#9880f0,
			#97bbee,
			#a2d8ee
		],
		[
			#b10000,//eye
			#8919a0,//gems
			#f800d0,
			#008858,//oranges
			#00a078,
			#00d0b8,
			#01452c,//black
			#006050,//greys
			#008878,
			#90c8a8,
			#abe9ae,
			#d3eec2
		],
		[
		#b10000,//eye
		#0f4eaa,//gems
		#52a0ef,
		#682c1d,//oranges
		#c93800,
		#f9a928,
		#202020,//black
		#2b1e24,//greys
		#383038,
		#505058,
		#788199,
		#b1b9c1
		]
	]
}