function BaseCharacter() constructor{
	self.default_health = 12;
	self.player = noone;
	self.image_folder = "x";
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
			animation: "dash"
		},
		jump: {
			strength: 1363/256,
			animation: "jump"
		},
		fall:{
			animation: "fall"
		},
		wall_jump: {
			strength: 5
		},
		ladder: {
			speed: 376/256
			//496/256 if its with arm parts
		},
		hurt: {
			speed: -138 / 256
		}
	}
	self.possible_armors = [
		[],//heads
		[],//arms
		[],//bodies
		[],//boots
		[]//full sets
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
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	
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