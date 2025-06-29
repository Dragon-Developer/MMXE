function Palette(_plt_sprite) constructor {
	static setSprite = function(_plt_sprite) {
	    self.index = 0;
		self.sprite = _plt_sprite;
	    self.indexUniform = shader_get_uniform(shdr_palette_swap, "u_paletteIndex");
	    self.textureSampler = shader_get_sampler_index(shdr_palette_swap, "u_paletteTexture");
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
		shader_set(shdr_palette_swap);
		shader_set_uniform_f(self.indexUniform, self.index / self.height);
		texture_set_stage(self.textureSampler, self.texture);
	}
	static reset = function() {
		shader_reset();	
	}
	self.setSprite(_plt_sprite);
}

// ive been letting this stew in my head for a while. i think it might be good to define a base palette texture
// and define the applied palette from there. this makes palette sharing easier, and is more accurate
// to how the snes would handle things, considering it allows one pallete to affect any entities that
// use the palette component

// future forte: naw i just put it in the animator. it could be good as a seperate thing but i dont
// see the benefit outside of keeping things as 1 job. 

function AltPalette(_plt_sprite, _alt_sprite) constructor {
	static setSprites = function(_plt_sprite, _alt_sprite) {
	    self.setMainSprite(_plt_sprite);
		self.setAltSprite(_alt_sprite)
	}
	static setMainSprite = function(_plt_sprite) {
		self.sprite = _plt_sprite;
	    self.textureSampler = shader_get_sampler_index(shdr_palette_alternate, "PaletteBase");
		log(textureSampler)
	    self.height = sprite_get_height(_plt_sprite);
	    self.width = sprite_get_width(_plt_sprite);
	    self.texture = sprite_get_texture(_plt_sprite, 0);
	}
	static setAltSprite = function(_alt_sprite) {
		self.alt_sprite = _alt_sprite;
	    self.textureSamplerAlt = shader_get_sampler_index(shdr_palette_alternate, "PaletteNew");
		log(textureSamplerAlt)
	    self.alt_texture = sprite_get_texture(_alt_sprite, 0);
	}
	static apply = function() {
		shader_set(shdr_palette_alternate);
		texture_set_stage(self.textureSampler, self.texture);
		texture_set_stage(self.textureSamplerAlt, self.alt_texture);
	}
	static reset = function() {
		shader_reset();	
	}
	self.setSprites(_plt_sprite, _alt_sprite);
}