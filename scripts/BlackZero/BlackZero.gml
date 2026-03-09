// I really wanna use the N-Word here but that's really dumb and immature.
function BlackZero() : ArmorBase() constructor{
	self.sprite_name = "/black"//this is more for filepath.
	
	self.buster_weapon = BlackSaber;
	
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		
		//self.add_slide(_player);
		_player.states.dash.speed *= 1.25;
		_player.states.walk.speed *= 1.25;
		_player.states.jump.strength *= 1.25;
		_player.find("animation").draw_base_sprite = false;
	}
	self.description = "Increased speed, jump height, and defense."
	self.damage_rate = 1/3;
}