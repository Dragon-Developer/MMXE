function ComponentAnimationShadered() : ComponentAnimation() constructor {
	self.shaders = [new Palette()];
	
	self.draw = function(){
		self.draw_apply_palette();
	}
	
	self.draw_apply_palette = function(){
		array_foreach(self.shaders, function(_shdr){
				_shdr.apply();
		})
		self.draw_regular();
		array_foreach(self.shaders, function(_shdr){
				_shdr.reset();
		})
	}
	
	self.set_palette_color = function(_index, _hex){
		self.shaders[0].setPaletteColorByHex(_index, _hex);
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
	
	self.set_base_color = function(_index, _hex){
		self.shaders[0].setBaseColorByHex(_index, _hex);
	}
}