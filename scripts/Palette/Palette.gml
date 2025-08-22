function Palette() constructor {
	static setSprite = function() {
		
		self.colorsArray = [
			[32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[48,64,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[128,240,248,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		];
		
		self.swapArray = [
			[128,160,240,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[48,64,90,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[1,2,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
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
	self.setSprite();
}

// ive been letting this stew in my head for a while. i think it might be good to define a base palette texture
// and define the applied palette from there. this makes palette sharing easier, and is more accurate
// to how the snes would handle things, considering it allows one pallete to affect any entities that
// use the palette component

// future forte: naw i just put it in the animator. it could be good as a seperate thing but i dont
// see the benefit outside of keeping things as 1 job. 

function AltPalette(_plt_sprite, _alt_sprite) constructor {
	self.textureSampler = noone;
	self.textureSamplerAlt = noone;
	self.texture = noone;
	self.alt_texture = noone;
	static setSprites = function(_plt_sprite, _alt_sprite) {
	    self.setMainSprite(_plt_sprite);
		self.setAltSprite(_alt_sprite)
	}
	static setMainSprite = function(_plt_sprite) {
		self.sprite = _plt_sprite;
	    self.textureSampler = shader_get_sampler_index(shdr_palette_alternate, "PaletteBase");
		self.textureWidth = shader_get_uniform(shdr_palette_swap, "width");
		log(textureSampler)
	    self.height = sprite_get_height(_plt_sprite);
	    self.width = sprite_get_width(_plt_sprite);
	    self.texture = sprite_get_texture(_plt_sprite, 0);
		log(self.texture);
	}
	static setAltSprite = function(_alt_sprite) {
		self.alt_sprite = _alt_sprite;
	    self.textureSamplerAlt = shader_get_sampler_index(shdr_palette_alternate, "PaletteNew");
		log(textureSamplerAlt)
	    self.alt_texture = sprite_get_texture(_alt_sprite, 0);
		log(self.alt_texture);
	}
	static apply = function() {
		shader_set(shdr_palette_alternate);
		texture_set_stage(self.textureSampler, self.texture);
		texture_set_stage(self.textureSamplerAlt, self.alt_texture);
		texture_set_stage(self.textureWidth, 16);
	}
	static reset = function() {
		shader_reset();	
	}
	self.setSprites(_plt_sprite, _alt_sprite);
}