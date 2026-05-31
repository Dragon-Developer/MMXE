function ComponentAnimationShadered() : ComponentAnimation() constructor {
	self.shaders = [new Palette()];
	self.part_shaders = [new Palette(), new Palette(), new Palette(), new Palette(), new Palette()];
	self.draw_cycle = 0;
	self.surface_size = 128;
	
	self.draw = function(){
		self.draw_apply_palette();
	}
	
	self.draw_action = function(_action, _modifier, _frame, _x, _y){
		if (array_contains(shaders,"flash")) {
			var _shad = new BrightShader()
			_shad.apply()
		}else
		part_shaders[draw_cycle].apply();
				
		self.animation.draw_action(_action,_modifier, _frame, _x, _y);
		
		if (array_contains(shaders,"flash")) 
			_shad.reset()
		else
		part_shaders[draw_cycle].reset();
		
		draw_cycle++;
	}
	
	self.draw_apply_palette = function(){
		
		if (array_contains(shaders,"gone")) 
			return;
		
		self.draw_cycle = 0;
		
		self.draw_regular();
	}
	
	self.set_palette_color = function(_index, _hex){
		self.part_shaders[0].setPaletteColorByHex(_index, _hex);
		self.part_shaders[1].setPaletteColorByHex(_index, _hex);
		self.part_shaders[2].setPaletteColorByHex(_index, _hex);
		self.part_shaders[3].setPaletteColorByHex(_index, _hex);
		self.part_shaders[4].setPaletteColorByHex(_index, _hex);
	}
	
	self.set_shader_color = function(_shader, _index, _hex){
		_shader.setPaletteColorByHex(_index, _hex);
	}
	
	self.set_palette_color_manual = function(_index, _red, _blue, _green){
		self.part_shaders[0].setPaletteColorManually(_index, _red, _blue, _green);
	}
	
	self.set_surface_size = function(_scale){
		self.surface_size = _scale;
	}
	
	self.get_palette_color = function(_index){
		var _shdr = self.part_shaders[0];
		var _ret = {
					red: _shdr.getPalette()[0][_index], 
					green: _shdr.getPalette()[1][_index], 
					blue: _shdr.getPalette()[2][_index]
				};
		return _ret;
	}
	
	self.get_base_color = function(_index){
		var _shdr = self.part_shaders[0];
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
		self.part_shaders[0].setBaseColorByHex(_index, _hex);
	}
	
	self.set_shader_base_color = function(_shader, _index, _hex){
		_shader.setBaseColorByHex(_index, _hex);
	}
}