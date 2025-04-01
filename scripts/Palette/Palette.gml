function Palette(_plt_sprite) constructor {
	static setSprite = function(_plt_sprite) {
	    self.index = 0;
		self.sprite = _plt_sprite;
	    self.indexUniform = shader_get_uniform(shdr_palette, "u_paletteIndex");
	    self.textureSampler = shader_get_sampler_index(shdr_palette, "u_paletteTexture");
	    self.height = sprite_get_height(_plt_sprite);
	    self.texture = sprite_get_texture(_plt_sprite, 0);
	}
	static setIndex = function(_index) {
		self.index = _index;
	}
	static getIndex = function() {
		return self.index;		
	};
	static apply = function() {
		shader_set(shdr_palette);
		shader_set_uniform_f(self.indexUniform, self.index / self.height);
		texture_set_stage(self.textureSampler, self.texture);
	}
	static reset = function() {
		shader_reset();	
	}
	self.setSprite(_plt_sprite);
}