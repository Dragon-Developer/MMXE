function BaseCharacter() constructor{
	self.default_health = 12;
	self.player = noone;
	self.image_folder = "x";
	self.boss_music = "BossBattleL"
	self.default_score = 1000;//for the score screen
	self.states = {	
		intro: {
			speed: 8,
			animation: "intro2"
		},
		walk: {
			speed: 376/256,	
			animation: "walk"
		},
		dash: {
			speed: 885/256,	
			interval: 32,
			animation: "dash",
			sound: "dash"
		},
		jump: {
			strength: 1363/256,
			animation: "jump",
			double_jump_animation: "jump",
			count: 1,
			sound: "jump",
			dash_jump_enabled: true
		},
		fall:{
			animation: "fall"
		},
		land:{
			sound: "land"
		},
		wall_slide: {
			speed: 2
		},
		wall_jump: {
			strength: 5,
			wall_stick: 5,
			launch_lock: 11,
			sound: "jump"
		},
		ladder: {
			speed: 376/256
			//496/256 if its with arm parts
		},
		hurt: {
			speed: -138 / 256,
			sound: "hurt"
		},
		dash_air: {
			speed: 885/256, 
			interval: 15, 
			max_dashes: 1, 
			curr_dashes: 0, 
			animation: "dash_air"
		}
	}
	self.possible_armors = [
		[noone],//heads
		[noone],//arms
		[noone],//bodies
		[noone],//boots
		[noone]//full set
	];
	self.armor_use_requirements = [];
	
	self.default_palette = [
		#203080,//Blue Armor Bits
		#0040f0,
		#0080f8,
		#1858b0,//Under Armor Teal Bits
		#50a0f0,
		#78d8f0,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#808080,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010,//red
		#989898//other grey
	];
	
	self.charge_colors = [
		[
			#216bf7,//Blue Armor Bits
			#0094f7,
			#00bdff,
			#1884e7,//Under Armor Teal Bits
			#52def7,
			#a5f7f7,
			#1852e7,//black
			#804020,//Face
			#b86048,
			#f8b080,
			#989898,//glove
			#e0e0e0,
			#f0f0f0,//eye white
			#f76bc6//red
		],
		[
			#216bf7,//Blue Armor Bits
			#0094f7,
			#00bdff,
			#1884e7,//Under Armor Teal Bits
			#52def7,
			#a5f7f7,
			#1852e7,//black
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
	
	self.weapons = [xBuster];
	self.weapon_ammo_max = 28;
	
	self.init = function(_player){
		self.init_default(_player);
	}
	
	self.init_default = function(_player){
		self.player = _player;
		//log(self.player)
		struct_foreach(self.states, function(_state){
			if(struct_exists(self.player.states, string(_state)))
				variable_struct_set(self.player.states, string(_state),
				variable_struct_get(self.states, _state))
		});
		_player.publish("character_set", self.image_folder)
		with(_player){
			find("animation").reload_animations();
		}
		var _animation = _player.find("animation");
		for(var i = 0; i < array_length(self.default_palette); i++){
			_animation.set_base_color(i, self.default_palette[i]);
		}
		for(var i = 0; i < array_length(self.default_palette); i++){
			_animation.set_palette_color(i, self.default_palette[i]);
		}
	}
}