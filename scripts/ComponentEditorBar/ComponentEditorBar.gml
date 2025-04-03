function ComponentEditorBar() : EntityComponentBase() constructor{
	#region generic information
		self.width = 96;
	#endregion
	#region Tileset Specific Information
		self.current_tileset_name = "TILESET:";
		self.tileset = 0;
		self.tile_options = [ts_engine, ts_gate_2];
	#endregion
	#region Object Specific Information
	#endregion
	#region Selection Specific Information
	#endregion
	

	self.draw = function(){
		draw_rectangle(GAME_W - self.width,0,GAME_W, GAME_H, false);
		draw_string(self.current_tileset_name, (GAME_W - self.width), 32);
		draw_string(asset_get_name(self.tile_options[self.tileset]), (GAME_W - self.width), 42);
		draw_string("X="+string(mouse_x), (GAME_W - self.width), 16);
		
		#region possible object selection
			array_foreach(self.tile_options, function(_element, _index) {
				draw_sprite(spr_selection,0,(GAME_W - self.width) - 1, 55 + 18 * _index)
				//draw_sprite_part(tileset_get_info(_element).texture, 0, 
				draw_sprite_part(spr_tileset_2, 0, 
				0, 16, 
				16, 16, 
				(GAME_W - self.width), 56 + 18 * _index);
			});
		#endregion
	}
}