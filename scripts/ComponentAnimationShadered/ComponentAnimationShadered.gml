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
	
	self.set_base_color = function(_index, _hex){
		self.shaders[0].setBaseColorByHex(_index, _hex);
	}
}