function Palette() constructor {
	static setSprite = function() {
		
		self.colorsArray = [
			[32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[48,64,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[128,240,248,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		];
		
		self.swapArray = [
			[32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[48,64,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[128,240,248,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		];
		
		for(var p = 0; p < 3; p++){
			for(var q = 0; q < 32; q++){
				self.colorsArray[p][q] = self.colorsArray[p][q]/ 255;
			}
		}
		
		for(var p = 0; p < 3; p++){
			for(var q = 0; q < 32; q++){
				self.swapArray[p][q] = self.swapArray[p][q] / 255;
			}
		}
		
	    self.RedColorsBase = shader_get_uniform(shdr_palette_swap, "RedColorsBase");
	    self.GreenColorsBase = shader_get_uniform(shdr_palette_swap, "GreenColorsBase");
	    self.BlueColorsBase = shader_get_uniform(shdr_palette_swap, "BlueColorsBase");
		
	    self.RedColorsSwap = shader_get_uniform(shdr_palette_swap, "RedColorsSwap");
	    self.GreenColorsSwap = shader_get_uniform(shdr_palette_swap, "GreenColorsSwap");
	    self.BlueColorsSwap = shader_get_uniform(shdr_palette_swap, "BlueColorsSwap");
	}
	
	static setPalette = function(_pal){
		self.swapArray = _pal;
	}
	static setBasePalette = function(_pal){
		self.colorsArray = _pal;
	}
	
	static apply = function() {
		shader_set(shdr_palette_swap);
		
		shader_set_uniform_f_array(self.RedColorsBase,   self.colorsArray[0])
		shader_set_uniform_f_array(self.GreenColorsBase, self.colorsArray[1])
		shader_set_uniform_f_array(self.BlueColorsBase,  self.colorsArray[2])
		
		shader_set_uniform_f_array(self.RedColorsSwap,   self.swapArray[0])
		shader_set_uniform_f_array(self.GreenColorsSwap, self.swapArray[1])
		shader_set_uniform_f_array(self.BlueColorsSwap,  self.swapArray[2])
	}
	static reset = function() {
		shader_reset();	
	}
	
	static setBaseColorAt = function(_index, _base_red, _base_green, _base_blue){
		array_set(self.colorsArray[0],_index, _base_red / 255)
		array_set(self.colorsArray[1],_index, _base_green / 255)
		array_set(self.colorsArray[2],_index, _base_blue / 255)
	}
	
	static setPaletteColorAt = function(_index, _new_red, _new_green, _new_blue){
		array_set(self.swapArray[0],_index, _new_red / 255)
		array_set(self.swapArray[1],_index, _new_green / 255)
		array_set(self.swapArray[2],_index, _new_blue / 255)
	}
	
	static setBaseColorByHex = function(_index, _hex){
		self.setBaseColorAt(
			_index, 
			color_get_red(_hex),
			color_get_green(_hex),
			color_get_blue(_hex)
		);
	}
	
	static setPaletteColorByHex = function(_index, _hex){
		self.setPaletteColorAt(
			_index, 
			color_get_red(_hex),
			color_get_green(_hex),
			color_get_blue(_hex)
		);
	}
	
	self.setSprite();
}