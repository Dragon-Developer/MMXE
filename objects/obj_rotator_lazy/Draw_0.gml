shader_set(shdr_palette_swap)

texture_set_stage(plt_swap_sampler, plt_texture);

shader_set_uniform_f(v_offset, (CURRENT_FRAME mod 8) / plt_width);
shader_set_uniform_f(v_source_offset, plt_source_index / plt_width);

draw_self();

shader_reset();