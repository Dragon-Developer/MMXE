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
		draw_sprite(X_Mugshot1, 0, self.get_instance().x, self.get_instance().y)
		self.palette.reset();
	}
}