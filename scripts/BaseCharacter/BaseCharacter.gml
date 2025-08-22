function BaseCharacter() constructor{
	self.default_health = 12;
	self.player = noone;
	self.image_folder = "x";
	self.states = {	
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
	self.states_default = {	
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
	self.possible_armors = [];
	self.armor_use_requirements = [];
	
	self.weapons = [xBuster];
	self.weapon_ammo_max = 28;
	
	self.init = function(_player){
		self.init_default(_player);
	}
	
	self.init_default = function(_player){
		self.player = _player;
		log(self.player)
		struct_foreach(self.states, function(_state){
			if(struct_exists(self.player.states, string(_state)))
				variable_struct_set(self.player.states, string(_state),
				variable_struct_get(self.states, _state))
		});
		_player.publish("character_set", self.image_folder)
		with(_player){
			get_instance().components.find("animation").reload_animations();
		}
		log(image_folder)
	}
}