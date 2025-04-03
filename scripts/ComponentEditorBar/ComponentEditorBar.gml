function ComponentEditorBar() : EntityComponentBase() constructor{
	
	/*
		all todo's
		
		Tilemap drawing
			-scrolling through selected tilemap to select proper tile
			-hiding the tile in the top left corner with an erase option
			-switching tilemaps
				-making a new layer if this tilemap does not already have a layer
				-changing the variable and making sure it doesnt make the game shit itself
			-rotating currently selected piece
			flipping currently selected piece
		Object placement
			-place objects
			-edit object data
				-rotation
				-x/y flip
				-position
				-scale
			-collision blocks
				-click and drag scaling
				-toggle view?
		Saving and loading
			-save file to json
			-load from json
				-tile data
				-object data
					-object specific information
						-x/y pos
						-x/y flip
						-scale
						-rotation
						-what object it is
	*/
	
	#region generic information
		self.width = 96;
		self.physics = noone;
		self.scrollbar_pos = 0;
		self.tool = 0;// 0 = select, 1 = tile, 2 = object
	#endregion
	#region Tileset Specific Information
		self.current_tileset_name = "TILESET:";
		self.tileset = 0;
		self.tile_options = [ts_engine, ts_gate_2];
		self.tile_sprites = [spr_tiles_engine_1, gate_tilesert];
		self.tile_layers = [];
		self.tile_placing = 0;
	#endregion
	#region Object Specific Information
	#endregion
	#region Selection Specific Information
	#endregion
	
	self.init = function(){
		self.add_layer();
	}
	self.add_layer = function(){
		var _layer = layer_create(0, "layer " + string(array_length(self.tile_layers)))
		array_push(tile_layers, _layer);
		layer_tilemap_create(_layer,0,0,self.tile_options[tileset],room_width, room_height);
	}
	
	self.step = function(){
		self.step_normal();
	}
	
	self.step_normal = function(){
		var _spd = 1;
		if(keyboard_check(ord("K")))
			_spd = 3;
		
		if(keyboard_check(vk_down)){
			self.get_instance().y++;
		} else if(keyboard_check(vk_up)){
			self.get_instance().y--;
		}
		if(keyboard_check(vk_left)){
			self.get_instance().x--;
		}if(keyboard_check(vk_right)){
			self.get_instance().x++;
		}
		
		self.get_instance().x = clamp(self.get_instance().x, GAME_W / 2, room_width - (GAME_W / 2))
		self.get_instance().y = clamp(self.get_instance().y, GAME_H / 2, room_height - (GAME_H / 2))
		
		self.tool_use();
	}
	
	self.tool_use = function(){
		switch(self.tool){
			case(0):
				if(mouse_check_button_pressed(mb_left))
					self.edit_tool();
			break;
			case(1):
			break;
			case(2):
			break;
		}
	}
	
	self.edit_tool = function(){
		var _id = layer_tilemap_get_id(self.tile_layers[tileset]);
		if((mouse_x-self.get_instance().x + GAME_W / 2)> GAME_W - self.width){
			var _gui_mouse_x = (mouse_x-self.get_instance().x + GAME_W / 2);
			if(mouse_y < 65)
				tile_placing = floor((_gui_mouse_x - (GAME_W - self.width)) / 16) + floor((mouse_y) / 16) * (sprite_get_width(self.tile_sprites[tileset]) / 16) 
			//else
				//change tileset. I need to make a new layer if this tileset doesnt exist, so changing tilesets should be a new method. 
				/*
					things change_tileset needs to do:
					 - change the active tileset layer
					 - if the new tileset layer does not exist or the array for tileset layers is too chunky, get a new layer
					 - if the new tileset layer already exists, go to that one. 
					 - change the tileset variable to the correct number
				*/
		}
		tilemap_set(_id, 
		tile_placing, 
		floor(mouse_x / 16), floor(mouse_y / 16));
		tilemap_set_mask(_id, tile_index_mask);  // optional for flipping & turning tiles in the tilemap
	}

	self.draw = function(){
		var _inst = self.get_instance();
		draw_sprite_ext(spr_block, 0, floor(mouse_x / 16) * 16, 
		floor(mouse_y / 16) * 16,
		1,1,0,c_orange,0.5)
	}

	self.draw_gui = function(){
		//reticle
		var _max_width =floor( self.width / 18)
		var _inst = self.get_instance();
		//tool window
		draw_rectangle(GAME_W - self.width,0,GAME_W, GAME_H, false);
		draw_rectangle(GAME_W - self.width - 16,96,GAME_W, GAME_H, false);
		//tileset specific
		draw_string(self.current_tileset_name, (GAME_W - self.width), 70);
		draw_string(self.tile_placing, (GAME_W - self.width), 60);
		draw_string(asset_get_name(self.tile_options[self.tileset]), (GAME_W - self.width), 80);
		
		#region possible object selection
		for(var p = 0; p < array_length(self.tile_sprites); p++){
			draw_sprite(spr_selection,0,(GAME_W - self.width) + 18 * (p mod _max_width), 
			96 + 18 * floor(p / _max_width))
			draw_sprite_part(self.tile_sprites[p], 0,
			//draw_sprite_part(_element, 0, 
			0, 16, 
			16, 16, 
			(GAME_W - self.width) + 1 + 18 * (p mod _max_width), 
			97 + 18 * floor(p / _max_width));
		}
		#endregion
		self.draw_tilemap_selection();
	}
	
	self.draw_tilemap_selection = function(){
		// my original idea was to have a second viewport to draw, which would show the tileset
		// but thinking about the way the mouse coords is gonna get fuckered up,
		// i think i will stick to the main viewport
		draw_sprite_part(self.tile_sprites[self.tileset], 0,
		0,1,self.width - 2,62, GAME_W - self.width + 1, 1);
		draw_sprite_ext(spr_grid,0, GAME_W - self.width + 
		(self.tile_placing mod (sprite_get_width(self.tile_sprites[self.tileset]) / 16)) * 16, 
		0  + floor((self.tile_placing / sprite_get_width(self.tile_sprites[tileset])) * 16)*16, 1, 1, 0, c_white, 0.9);
		draw_sprite_ext(spr_grid,0, GAME_W - self.width + 
		(self.tile_placing mod (sprite_get_width(self.tile_sprites[self.tileset]) / 16)) * 16 + 17, 
		17 + floor((self.tile_placing / sprite_get_width(self.tile_sprites[tileset])) * 16)*16, 1, 1, 180, c_white, 0.9);
	}
}