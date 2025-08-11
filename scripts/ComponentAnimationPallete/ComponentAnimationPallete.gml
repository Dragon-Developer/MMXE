function ComponentAnimationPalette() : ComponentAnimation() constructor {
	self.palette = new Palette(xpal);
	
	self.draw = function(){
		self.draw_regular();
	}
	
	self.draw_apply_palette = function(){
		self.palette.apply();
		self.draw_regular();
		self.palette.reset();
	}
}