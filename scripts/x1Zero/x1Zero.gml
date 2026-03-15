// I really wanna use the N-Word here but that's really dumb and immature.
function X1Zero() : ArmorBase() constructor{
	self.sprite_name = "/x1"//this is more for filepath.
	self.selectable = true;
	
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		
		//self.add_slide(_player);
		_player.states.jump.double_jump_animation = "jump"
		_player.states.jump.count = 1;
		
		_player.find("animation").draw_base_sprite = false;
		global.availible_characters[global.character_index].weapons = [xBuster, FireWave, ElectricWeb, ShotgunIce, WaveBurner, RollingShield];
		global.availible_characters[global.character_index].default_palette = [
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
		
		
		var _animation = _player.find("animation");
		for(var i = 0; i < array_length(global.availible_characters[global.character_index].default_palette); i++){
			_animation.set_base_color(i, global.availible_characters[global.character_index].default_palette[i]);
		}
		_player.get(ComponentWeaponUse).weapon_list = [xBuster, FireWave, ElectricWeb, ShotgunIce, WaveBurner, RollingShield];
	}
	self.description = "Undoes all changes, and makes the user capable of using special weapons."
	//self.damage_rate = 1/3;
}