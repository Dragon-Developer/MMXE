function ComponentEditorBar() : ComponentBase() constructor{
	#region checklist
	/*
		all todo's
		
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
				-object data
					-object specific information
						-x/y pos
						-x/y flip
						-scale
						-rotation
						-what object it is
			-.mmxlv
				-we dont need 2 seperate files. i already fixed that issue
				-level data, then object data
					-need to select a delimiter. keep in mind the file size is multiplied by each 
						character in the delimiter because the delimiters are used to seperate
						everything in the level data
							-could be #x#. this looks too much like uwu. i heavily dislike uwu.
	*/
	#endregion
	
	#region generic information
		self.width = 96;
		self.physics = noone;
		self.scrollbar_pos = 0;
		self.tool = false; //false = tile, true = object. no selecting needed, i can do that via object
		self.mouse_select_padding = 2;
		self.map_name = "undefined oof"
		self.save_notification_timer = 0;
		self.delimiter = "%&"
	#endregion
	#region Tileset Specific Information
		self.current_tileset_name = "TILESET:";
		self.tileset = 0;
		self.tile_options = [ts_engine, ts_gate_2];
		self.tile_sprites = [spr_tiles_engine_1, gate_tilesert];
		self.tile_layers = [];
		self.tile_placing = 0;
		self.tilemap_scroll_x = 0;
		self.tilemap_scroll_y = 0;
		self.tile_flipped = false;
		self.tile_mirrored = false;
		self.tile_rotated = false;
	#endregion
	#region Object Specific Information
		self.objects = [];// every single object. will probably place an object limit. 
		self.current_object = 0;
		self.object_options = [obj_player_spawner, obj_square_16];// the objects the player can select
		// i shouldnt need a fuckton of variables for objects. you select the object, it holds
		// all of it's data that it needs, and this script doesnt hold it outside of local vars
	#endregion
	
	self.init = function(){
		self.add_layer(self.tile_options[0]);
		ini_open("temp_ini.ini");
		ini_close();
	}
	self.add_layer = function(_ts){
		var _layer = layer_create(0, "layer " + string(array_length(self.tile_layers)))
		array_push(self.tile_layers, _layer);
		log(_ts)
		layer_tilemap_create(_layer,0,0,_ts,room_width, room_height);
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
					self.tile_tool();
			break;
			case(1):
			break;
		}
		
		if(keyboard_check(vk_control) && keyboard_check_pressed(ord("S")))
			self.save();
		if(keyboard_check_pressed(ord("L")))
			self.load();
			
		if(get_mouse_click(GAME_W - self.width - 16, 0, GAME_W - self.width, 16)){
				log("mouse clicked on the save button")
				var _lvlname = get_string("Save Level As?", self.map_name);
				self.map_name = _lvlname;
				self.save();
			} else if(get_mouse_click(GAME_W - self.width - 16, 16, GAME_W - self.width, 32)){
				log("mouse clicked on the load button")
				//this should bring up a GUI that lets you select the level from there. 
				//selecting levels via this get_string method is really janky
				var _lvlname = get_string("Load Which Level?", self.map_name);
				self.map_name = _lvlname;
				self.load();
			} else if(get_mouse_click(GAME_W - self.width - 16, 32, GAME_W - self.width, 48)){
				log("mouse clicked on the Select Tool button")
			} else if(get_mouse_click(GAME_W - self.width - 16, 48, GAME_W - self.width, 64)){
				log("mouse clicked on the Tile Tool button")
			} else if(get_mouse_click(GAME_W - self.width - 16, 64, GAME_W - self.width, 80)){
				log("mouse clicked on the Object Tool button")
			} else if(get_mouse_click(GAME_W - self.width - 16, 80, GAME_W - self.width, 96)){//these next 3 only exist in the tile tool{
				log("mouse clicked on the mirror button")
				self.tile_mirrored = !self.tile_mirrored
			} else if(get_mouse_click(GAME_W - self.width - 16, 96, GAME_W - self.width, 112)){
				log("mouse clicked on the flip button")
				self.tile_flipped = !self.tile_flipped;
			} else if(get_mouse_click(GAME_W - self.width - 16, 112, GAME_W - self.width, 128)){
				log("mouse clicked on the rotate button")
				self.tile_rotated = !self.tile_rotated;
			}
	}
	
	self.tile_tool = function(){
		var _id = layer_tilemap_get_id(self.tile_layers[tileset]);
		
		//this implementation is ass. needs to be redone to have a dragging_ui bool that is on when you click the edge and off when you release the mouse. 
		if(get_mouse_down(GAME_W - self.width - 18, 0, GAME_W - self.width - 14, GAME_H)){
			log(GAME_W - (mouse_x - self.get_instance().x + GAME_W / 2))
			log(self.width);
			self.width = GAME_W - (mouse_x - self.get_instance().x + GAME_W / 2) - 16;
			self.width = clamp(self.width, 18, 240);// there doesnt NEED to be an upper limit but it would be preferable to not have the ability to block your vision out
		}
		if((mouse_x-self.get_instance().x + GAME_W / 2)> GAME_W - self.width - 18){
			var _gui_mouse_x = (mouse_x-self.get_instance().x + GAME_W / 2);
			var _gui_mouse_y = (mouse_y-self.get_instance().y + GAME_H / 2);
			if(_gui_mouse_y< 65 && _gui_mouse_x > GAME_W - self.width){
				if(mouse_check_button_pressed(mb_left))
					tile_placing = 
					floor((_gui_mouse_x - (GAME_W - self.width) + self.tilemap_scroll_x) / 16) + 
					floor((_gui_mouse_y + self.tilemap_scroll_y) / 16) * (sprite_get_width(self.tile_sprites[tileset]) / 16) 
				
				if(_gui_mouse_y > 63 - mouse_select_padding){
					self.tilemap_scroll_y++;
				} else if(_gui_mouse_y < mouse_select_padding){
					self.tilemap_scroll_y--;
				}
				
				if(_gui_mouse_x < GAME_W - self.width + mouse_select_padding + 1){
					self.tilemap_scroll_x--;
				} else if(_gui_mouse_x > GAME_W - mouse_select_padding - 1){
					self.tilemap_scroll_x++;
				}
				self.tilemap_scroll_x = clamp(self.tilemap_scroll_x, 0, sprite_get_width(self.tile_sprites[tileset]) - self.width);
				self.tilemap_scroll_y = clamp(self.tilemap_scroll_y, 0, sprite_get_height(self.tile_sprites[tileset]) - 64);
				
			}
			else
			{
				//check if the next tileset is selectable. get the grid width and if the selected object is outside of the
				//bounds of the tileset array just cancel the operation.
				if(get_mouse_click(GAME_W - self.width, 65, GAME_W, GAME_H)){
					var _max_width = floor( self.width / 18)
					var _mouse_segment_x = floor((_gui_mouse_x - GAME_W + self.width) / 18);
					var _mouse_segment_y = floor((_gui_mouse_y - 49) / 18);//need to verify if 65 is the right call
					var _res = _mouse_segment_x * _mouse_segment_y;
					if(_mouse_segment_x > _max_width || _res > array_length(self.tile_options) || _res < 0) return;
					
					self.tileset = _res;
					
					for(var e = 0; e < array_length(layer_get_all()); e++){
						var _layer = layer_tilemap_get_id(layer_get_all()[e]);
						var _tmap = tilemap_get_tileset(_layer);
						if(_tmap = self.tile_options[self.tileset]){
							return;// if we already have a tilemap for this tileset, dont do anything because we dont need to set shit up
						}
					}
					// you can only get here if the tileset does in fact not have a layer assigned to it yet.
					// this means there's only one layer per tileset but it still works out pretty well if
					// you know what youre doing with tilesets.
					add_layer(self.tile_options[self.tileset]);
				}
			}
		} else {
			if(mouse_check_button_pressed(mb_right)){
				tilemap_set(_id, 
				0, 
				floor(mouse_x / 16), floor(mouse_y / 16));
			}
			if(mouse_check_button_pressed(mb_left)){
				tilemap_set(_id, 
				tile_placing, 
				floor(mouse_x / 16), floor(mouse_y / 16));
				tilemap_set(_id, 
				tile_set_rotate(tilemap_get(_id,floor(mouse_x / 16), floor(mouse_y / 16)), self.tile_rotated),
				floor(mouse_x / 16), floor(mouse_y / 16));
				tilemap_set(_id, 
				tile_set_flip(tilemap_get(_id,floor(mouse_x / 16), floor(mouse_y / 16)), self.tile_flipped),
				floor(mouse_x / 16), floor(mouse_y / 16));
				tilemap_set(_id, 
				tile_set_mirror(tilemap_get(_id,floor(mouse_x / 16), floor(mouse_y / 16)), self.tile_mirrored),
				floor(mouse_x / 16), floor(mouse_y / 16));
			}
		}
	}
		
	self.object_tool = function(){
			
	}
	
	self.get_mouse_click = function(_x1, _y1, _x2, _y2){
		var _gui_mouse_x = (mouse_x-self.get_instance().x + GAME_W / 2);
		var _gui_mouse_y = (mouse_y-self.get_instance().y + GAME_H / 2);
		
		if(_gui_mouse_x < _x2 && _gui_mouse_x > _x1 && _gui_mouse_y < _y2 && _gui_mouse_y > _y1 && mouse_check_button_pressed(mb_left)){
			return true;
		}
		return false;
	}
	
	self.get_mouse_down = function(_x1, _y1, _x2, _y2){
		var _gui_mouse_x = (mouse_x-self.get_instance().x + GAME_W / 2);
		var _gui_mouse_y = (mouse_y-self.get_instance().y + GAME_H / 2);
		
		if(_gui_mouse_x < _x2 && _gui_mouse_x > _x1 && _gui_mouse_y < _y2 && _gui_mouse_y > _y1 && mouse_check_button(mb_left)){
			return true;
		}
		return false;
	}

	self.draw = function(){
		var _inst = self.get_instance();
		draw_sprite_ext(spr_block, 0, floor(mouse_x / 16) * 16, 
		floor(mouse_y / 16) * 16,
		1,1,0,c_orange,0.5)
	}

	self.draw_gui = function(){
		var _inst = self.get_instance();
		draw_string((mouse_x - _inst.x + GAME_W / 2), 4,0);
		draw_string((mouse_y - _inst.y + GAME_H / 2), 4,10);
		if(self.save_notification_timer > 0){
			draw_string_condensed("SAVED TO " + working_directory,0,20);
			self.save_notification_timer--;
		}
		//tool window
		draw_rectangle(GAME_W - self.width,0,GAME_W, GAME_H, false);
		draw_rectangle(GAME_W - self.width - 16,96,GAME_W, GAME_H, false);
		//tileset specific
		self.draw_tilemap_selection();
	}
	
	self.draw_tilemap_selection = function(){
		var _inst = self.get_instance();
		
		draw_sprite(spr_selection,0,GAME_W - (self.width / 2) - 9, 69);// no this is not a funny number
		draw_sprite_part(self.tile_sprites[self.tileset],0,
		self.tile_placing mod floor(sprite_get_width(self.tile_sprites[self.tileset]) / 16),
		floor(self.tile_placing / sprite_get_width(self.tile_sprites[self.tileset]) / 16),
		16,16,GAME_W - (self.width / 2) - 8,70)
		
		#region tilemap selection
		// draw the tileset itself
		draw_sprite_part(self.tile_sprites[self.tileset], 0,
		self.tilemap_scroll_x,self.tilemap_scroll_y,
		self.width - 2,62, GAME_W - self.width + 1, 1);
		
		if(self.tilemap_scroll_x < 16)
			draw_sprite(spr_editor_icons,0, GAME_W - self.width - self.tilemap_scroll_x,-self.tilemap_scroll_y);
		
		//draw the reticle
		if((self.tile_placing mod (sprite_get_width(self.tile_sprites[self.tileset]) / 16)) * 16 - self.tilemap_scroll_x > GAME_W - self.width - 15)
		draw_sprite_ext(spr_grid,0, GAME_W - self.width + 
		(self.tile_placing mod (sprite_get_width(self.tile_sprites[self.tileset]) / 16)) * 16 - self.tilemap_scroll_x, 
		0  + floor((self.tile_placing / sprite_get_width(self.tile_sprites[tileset])) * 16)*16 - self.tilemap_scroll_y, 1, 1, 0, c_white, 0.9);
		if((self.tile_placing mod (sprite_get_width(self.tile_sprites[self.tileset]) / 16)) * 16 + 17 - self.tilemap_scroll_x > GAME_W - self.width - 15)
		draw_sprite_ext(spr_grid,0, GAME_W - self.width + 
		(self.tile_placing mod (sprite_get_width(self.tile_sprites[self.tileset]) / 16)) * 16 + 17 - self.tilemap_scroll_x, 
		17 + floor((self.tile_placing / sprite_get_width(self.tile_sprites[tileset])) * 16)*16 - self.tilemap_scroll_y, 1, 1, 180, c_white, 0.9);
		
		draw_rectangle_color(GAME_W - self.width, 0, GAME_W, mouse_select_padding - 1, c_orange, c_orange, c_orange, c_orange,false);
		draw_rectangle_color(GAME_W - self.width, 65, GAME_W, 64 - mouse_select_padding, c_orange, c_orange, c_orange, c_orange,false);
		
		draw_rectangle_color(GAME_W - self.width,0 , GAME_W - self.width + mouse_select_padding - 1, 64, c_orange, c_orange, c_orange, c_orange,false);
		draw_rectangle_color(GAME_W,0 , GAME_W - mouse_select_padding - 1, 64, c_orange, c_orange, c_orange, c_orange,false);
		#endregion
		
		#region possible object selection
		var _max_width = floor( self.width / 18)
		for(var p = 0; p < array_length(self.tile_sprites); p++){
			if(p == self.tileset)
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
		
		#region buttons
			draw_sprite(spr_editor_icons,0, GAME_W - self.width - 16,0);
			draw_sprite(spr_editor_icons,7, GAME_W - self.width - 16,16);
			draw_sprite(spr_editor_icons,1, GAME_W - self.width - 16,32);
			draw_sprite(spr_editor_icons,2, GAME_W - self.width - 16,48);
			draw_sprite(spr_editor_icons,3, GAME_W - self.width - 16,64);
			if(self.tile_mirrored)
				draw_sprite(spr_editor_icons,9, GAME_W - self.width - 16,80);//rotate
			else
				draw_sprite(spr_editor_icons,4, GAME_W - self.width - 16,80);//mirror
			if(self.tile_flipped)
				draw_sprite(spr_editor_icons,10, GAME_W - self.width - 16,96);//rotate
			else
				draw_sprite(spr_editor_icons,5, GAME_W - self.width - 16,96);//flip
			if(self.tile_rotated)
				draw_sprite(spr_editor_icons,11, GAME_W - self.width - 16,112);//rotate
			else
				draw_sprite(spr_editor_icons,6, GAME_W - self.width - 16,112);//rotate
		#endregion
	}
	
	self.save = function(){
		var _sav = file_text_open_write(self.map_name + ".mmxlv");// if the megaman maker crew complains about this i will shove my foot up their ass about it
		
		
		for(var h = 0; h < room_height / 16; h++){
			for(var w = 0; w < room_width / 16; w++){
				file_text_write_string(_sav, 
					tilemap_get(layer_tilemap_get_id(self.tile_layers[tileset]), w, h)
				);
				file_text_write_string(_sav, self.delimiter);
			}
			file_text_writeln(_sav);
		}
		file_text_close(_sav);
		self.save_notification_timer = 180;
	}
	
	self.load = function(){
		var _sav = file_text_open_read(self.map_name + ".mmxlv");// if the megaman maker crew complains about this i will shove my foot up their ass about it
		if(!file_exists(self.map_name + ".mmxlv")){
			log("this file does not exist so i will now shit thyself")
			return;
		}
		var _lvl = file_text_read_string(_sav);
		_lvl = string_split(_lvl, self.delimiter);// "$%^&" is the 'delimiter', which seperates the different parts of the level
		// it would be better for me to have a smaller delimiter, because each character effectively multiplies file size
		var _id = layer_tilemap_get_id(self.tile_layers[tileset]);
		for(var h = 0; h < room_height / 16; h++){
			for(var w = 0; w < room_width / 16; w++){
				if(w < array_length(_lvl))
					if(_lvl[w] != ""){
						tilemap_set(_id, 
						real(_lvl[w]), 
						w,h);
						tilemap_set_mask(_id, tile_index_mask);
					}
			}
			file_text_readln(_sav);
			var _lvl = file_text_read_string(_sav);
			_lvl = string_split(_lvl, self.delimiter);
		}
		file_text_close(_sav);
	}
}