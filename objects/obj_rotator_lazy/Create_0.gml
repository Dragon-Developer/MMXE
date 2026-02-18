//test shit
plt_index = 3;
plt_index_default = 0;
plt_source_index = 0;

plt_width = 16;
plt_texture = sprite_get_texture(xpal, 0);

v_offset = shader_get_uniform(shdr_palette_swap, "Offset");
v_source_offset = shader_get_uniform(shdr_palette_swap, "OffsetSource");

// Sampler and texture variables
plt_swap_sampler = shader_get_sampler_index(shdr_palette_swap, "Palette");