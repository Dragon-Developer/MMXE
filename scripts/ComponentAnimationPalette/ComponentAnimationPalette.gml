function ComponentAnimationPalette() : ComponentAnimation() constructor {
	self.palette = new Palette();
	
	self.draw = function(){
		self.draw_apply_palette();
	}
	
	self.draw_apply_palette = function(){
		self.palette.apply();
		self.draw_regular();
		self.palette.reset();
	}
	
	self.set_palette_color = function(_index, _hex){
		self.palette.setPaletteColorByHex(_index, _hex);
	}
	
	self.set_base_color = function(_index, _hex){
		self.palette.setBaseColorByHex(_index, _hex);
	}
}