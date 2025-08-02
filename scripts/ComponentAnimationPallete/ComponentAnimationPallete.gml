function ComponentAnimationPalette() : ComponentAnimation() constructor {
	self.palette = new Palette(xpal);
	self.init = function(){
		
	}
	
	self.draw = function(){
		self.draw_apply_palette();
	}
	
	self.draw_apply_palette = function(){
		self.palette.apply();
		self.draw_regular();
		self.palette.reset();
	}
}