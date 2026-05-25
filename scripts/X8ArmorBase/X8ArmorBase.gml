function X8ArmsBase() : X8PartBase() constructor{
	self.sprite_name = "/x8/arms"//this is more for filepath.
	self.part_palette = 2;
}

function X8BodyBase() : X8PartBase() constructor{
	self.sprite_name = "/x8/body"//this is more for filepath.
	self.part_palette = 3;
}

function X8HelmBase() : X8PartBase() constructor{
	self.sprite_name = "/x8/helm"//this is more for filepath.
	self.part_palette = 1;
}

function X8BootBase() : X8PartBase() constructor{
	self.sprite_name = "/x8/legs"//this is more for filepath.
	self.part_palette = 4;
}

function X8PartBase() : ArmorBase() constructor{
	self.sprite_name = "/x1/legs"//this is more for filepath.
	self.palette = [];
	self.paletted = 0;
	self.part_palette = 0;
	
	self.set_default_palette = function(_player, _default_palette = [ #f8e890, #e88840, #a86040, #ffb4ff, #e67be6, #bb2bbb, #695e6f, #363641, #27272c, #8d2bba, #60008d]){
	
		palette = _default_palette;
			
		if(array_length(global.availible_characters[global.character_index].default_palette) >= 18)
		if(global.availible_characters[global.character_index].default_palette[15] == #f8e890) return;
			
		var _animation = _player.find("animation");
		
		//gold
		array_push(global.availible_characters[global.character_index].default_palette, #f8e890);
		array_push(global.availible_characters[global.character_index].default_palette, #e88840);
		array_push(global.availible_characters[global.character_index].default_palette, #a86040);
		
		//purples
		array_push(global.availible_characters[global.character_index].default_palette, #ffb4ff);
		array_push(global.availible_characters[global.character_index].default_palette, #e67be6);
		array_push(global.availible_characters[global.character_index].default_palette, #bb2bbb);
		
		//dark greys
		array_push(global.availible_characters[global.character_index].default_palette, #695e6f);
		array_push(global.availible_characters[global.character_index].default_palette, #3d3d41);
		array_push(global.availible_characters[global.character_index].default_palette, #27272c);
		
		//gem
		array_push(global.availible_characters[global.character_index].default_palette, #8d2bba);
		array_push(global.availible_characters[global.character_index].default_palette, #60008d);
		
		
		for(var i = 0; i < array_length(global.availible_characters[global.character_index].default_palette); i++){
			_animation.set_base_color(i, global.availible_characters[global.character_index].default_palette[i]);
		}
	}
	
	self.step_armor_effects = function(_player){
		if(paletted < 32){
			set_palette(_player)
		}
	}
	
	self.set_palette = function(_player){
		var _animation = _player.find("animation");
			
		var _pal = variable_clone(palette);
		
		if !is_array(_pal) return;
			
		if _player.find("weapon") && global.settings.x8_armors_show_special_weapons{
			if _player.find("weapon").current_weapon[0] > 0 {
				_pal[3] = _player.find("weapon").weapon_palette[2]
				_pal[4] = _player.find("weapon").weapon_palette[1]
				_pal[5] = _player.find("weapon").weapon_palette[0]
			}
		}
			
		_animation.set_shader_color(_animation.part_shaders[part_palette], 15, _pal[0]);
		_animation.set_shader_color(_animation.part_shaders[part_palette], 16, _pal[1]);
		_animation.set_shader_color(_animation.part_shaders[part_palette], 17, _pal[2]);
		_animation.set_shader_color(_animation.part_shaders[part_palette], 18, _pal[3]);
		_animation.set_shader_color(_animation.part_shaders[part_palette], 19, _pal[4]);
		_animation.set_shader_color(_animation.part_shaders[part_palette], 20, _pal[5]);
		_animation.set_shader_color(_animation.part_shaders[part_palette], 21, _pal[6]);
		_animation.set_shader_color(_animation.part_shaders[part_palette], 22, _pal[7]);
		_animation.set_shader_color(_animation.part_shaders[part_palette], 23, _pal[8]);
		_animation.set_shader_color(_animation.part_shaders[part_palette], 24, _pal[9]);
		_animation.set_shader_color(_animation.part_shaders[part_palette], 25, _pal[10]);
			
		// i totally could optimize this but i dont feel like it
		for(var w = 0; w < 5; w++){
			for(var q = 0; q < 31; q++){
				var _pal = _animation.get_base_color(q)
				var _col = make_color_rgb(_pal.red * 255, _pal.green * 255, _pal.blue * 255)
				_animation.set_shader_base_color(_animation.part_shaders[w], q, _col);
			}
		}
			
		//if paletted >= 0
		//paletted++;
	}
}