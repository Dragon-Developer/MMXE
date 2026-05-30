function ComponentAnimationShadered() : ComponentAnimation() constructor {
	self.shaders = [new Palette()];
	self.part_shaders = [new Palette(), new Palette(), new Palette(), new Palette(), new Palette()];
	self.draw_cycle = 0;
	self.surface_size = 128;
	
	self.draw = function(){
		self.draw_apply_palette();
	}
	
	self.draw_action = function(_action, _modifier, _frame, _x, _y){
		part_shaders[draw_cycle].apply();
				
		self.animation.draw_action(_action,_modifier, _frame, surface_size / 2, surface_size / 2);
		
		part_shaders[draw_cycle].reset();
		
		draw_cycle++;
	}
	
	self.draw_apply_palette = function(){
		//surface_reset_target();
		
		//for the autistic guy that's helping test stuff
		//he gets errors with surfaces. this is the only new surface added
		//return;
		
		self.draw_cycle = 0;
		
		var _surf = surface_create(surface_size, surface_size)
		surface_set_target(_surf);
		self.draw_regular();
		surface_reset_target();
		
		array_foreach(self.shaders, function(_shdr){
			_shdr.apply();
		})
		
		draw_surface(_surf, floor(self.get_instance().x - surface_size / 2), floor(self.get_instance().y - surface_size / 2))
		surface_free(_surf)
		
		array_foreach(self.shaders, function(_shdr){
			_shdr.reset();
		})
		//surface_reset_target();
		
		if surface_get_target() != application_surface{
			//var _success = file_text_open_read(game_save_id + "IT WORKED TELL FORTE IT WORKED.txt")
			//file_text_close(_success)
			surface_reset_target()
		} else {
			//var _success = file_text_open_read(game_save_id + "DAMMIT TELL FORTE IT DONT WORK.txt")
			//file_text_close(_success)
		}
	}
	
	self.set_palette_color = function(_index, _hex){
		self.shaders[0].setPaletteColorByHex(_index, _hex);
	}
	
	self.set_shader_color = function(_shader, _index, _hex){
		_shader.setPaletteColorByHex(_index, _hex);
	}
	
	self.set_palette_color_manual = function(_index, _red, _blue, _green){
		self.shaders[0].setPaletteColorManually(_index, _red, _blue, _green);
	}
	
	self.get_palette_color = function(_index){
		var _shdr = self.shaders[0];
		var _ret = {
					red: _shdr.getPalette()[0][_index], 
					green: _shdr.getPalette()[1][_index], 
					blue: _shdr.getPalette()[2][_index]
				};
		return _ret;
	}
	
	self.get_base_color = function(_index){
		var _shdr = self.shaders[0];
		var _ret = {
					red: _shdr.getBase()[0][_index], 
					green: _shdr.getBase()[1][_index], 
					blue: _shdr.getBase()[2][_index]
				};
		return _ret;
	}
	
	self.get_shader_color = function(_shader, _index){
		var _shdr = _shader;
		var _ret = {
					red: _shdr.getPalette()[0][_index], 
					green: _shdr.getPalette()[1][_index], 
					blue: _shdr.getPalette()[2][_index]
				};
		return _ret;
	}
	
	self.get_shader_base_color = function(_shader, _index){
		var _shdr = _shader;
		var _ret = {
					red: _shdr.getBase()[0][_index], 
					green: _shdr.getBase()[1][_index], 
					blue: _shdr.getBase()[2][_index]
				};
		return _ret;
	}
	
	self.set_base_color = function(_index, _hex){
		self.shaders[0].setBaseColorByHex(_index, _hex);
	}
	
	self.set_shader_base_color = function(_shader, _index, _hex){
		_shader.setBaseColorByHex(_index, _hex);
	}
}