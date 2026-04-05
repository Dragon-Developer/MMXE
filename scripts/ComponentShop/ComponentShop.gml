function ComponentShop() : ComponentInteractibleInteract() constructor{

	/*
	
	lock the player
	
	show options
	
	jump/dash - select
	
	shoot - leave
	
	
	
	*/

	shop_items = global.shop_items;
	shop_structs = [];
	shop_prices = global.shop_prices;
	
	item_draw_count = 3; //only counts one direction
	item_draw_radius = 32; // how far away the last item is from the center
	
	shop_draw_x_offset = -170;
	shop_draw_y_offset = -64;
	shop_draw_x_real_offset = -200;
	shop_draw_y_real_offset = -96;
	
	shop_draw_width = 128;
	shop_draw_height = 12;
	
	shop_rot = 0
	shop_rot_dir = 1;
	shop_rot_time = 8;
	
	shop_index = 0;
	
	self.init = function(){
		get(ComponentAnimation).set_subdirectories(
		["/npc"]);
		publish("character_set", "stage");
		publish("animation_play", { name: "welder"});
		publish("animation_xscale", -1);
		
		array_foreach(shop_items, function(_item, _index){
			shop_structs[_index] = {};
			
			with(shop_structs[_index]){
				script_execute(_item)
			}
		});
		get_instance().depth = 550;
	}
	
	self.step = function(){
		self.get_interacting();
		
		if(interacted){
			shop_draw_x_real_offset = lerp(shop_draw_x_real_offset, shop_draw_x_offset, 0.1)
			
			var _input = get(ComponentPlayerInput)
			var _vdir = _input.get_input_pressed("up") - _input.get_input_pressed("down")
			
			//change item
			if _vdir != 0 && shop_rot == 0{
				shop_rot = shop_rot_time;
				shop_rot_dir = _vdir;
				shop_index = (shop_index + _vdir + array_length(shop_items)) mod array_length(shop_items)
			}
			
			//purchase
			if(_input.get_input_pressed("jump") || _input.get_input_pressed("dash")) && global.player_data.metals >= shop_prices[shop_index] && !array_contains(global.settings.shop_items, shop_index){
				//buy something will ya?
				array_push(global.settings.shop_items, shop_index);
				global.player_data.metals -= shop_prices[shop_index];
			}
			
			//bail
			if(_input.get_input_pressed("shoot") || _input.get_input_pressed("pause")){
				with(obj_entity){
					if(variable_struct_exists(components, "__components"))
						array_foreach(components.__components, function(_comp){
							_comp.step_enabled = true;
						})
				}
				interacted = false;
				with(obj_player){
					components.get(ComponentArmorHandler).reapply();
				}
			}
		}
	}
	
	self.draw = function(){
		self.draw_interact_arrow();
		if interacted {
			draw_shop_options()
		}
		if(shop_rot > 0)
			shop_rot = (shop_rot +- 1) mod shop_rot_time
	}
	
	self.draw_shop_options = function(){
		
		var _rot = 0
		var _x = shop_draw_x_real_offset - item_draw_radius - 6
		var _y = shop_draw_y_real_offset - item_draw_radius - 6
		var _item_index = 0
		var _text_type = "normal"
		var _inst = get_instance();
		
		//money display
		draw_string("Metals: " + string(global.player_data.metals), _inst.x + _x, _inst.y + _y, "pause menu")
		
		//top item
		for(var t = 1; t < item_draw_count ; t++){
			 _rot = ((t + shop_rot / shop_rot_time * -1 * shop_rot_dir) / item_draw_count) * (pi / 2) + pi
			 _x = shop_draw_x_real_offset + sin(_rot) * item_draw_radius
			 _y = shop_draw_y_real_offset + cos(_rot) * item_draw_radius
			
			//draw_sprite(spr_lemon_mask, 0, _inst.x + _x, _inst.y + _y);
			draw_set_color(#f0f0f0)
			draw_rectangle(_inst.x + _x - 1, _inst.y + _y - 1, _inst.x + _x + shop_draw_width + 1, _inst.y + _y + shop_draw_height + 1, false)
			draw_set_color(c_black)
			draw_rectangle(_inst.x + _x, _inst.y + _y, _inst.x + _x + shop_draw_width, _inst.y + _y + shop_draw_height, false)
			
			draw_string(shop_structs[(item_draw_count - t + shop_index + array_length(shop_items)) mod array_length(shop_items)].armor_name, _inst.x + _x + 1, _inst.y + _y + 3)
			
			_item_index = (item_draw_count - t + shop_index + array_length(shop_items)) mod array_length(shop_items)
			
			if(array_contains(global.settings.shop_items, _item_index) || global.shop_prices[_item_index] > global.player_data.metals)
				_text_type = "orange"
			else 
				_text_type = "normal"
			
			draw_string(shop_prices[_item_index], _inst.x + _x - 24, _inst.y + _y + 3, _text_type)
		}
		
		//bottom items
		for(var t = 1; t < item_draw_count ; t++){
			 _rot = ((t + shop_rot / shop_rot_time * shop_rot_dir) / item_draw_count) * (pi / 2) 
			 _x = shop_draw_x_real_offset + sin(_rot * -1) * item_draw_radius
			 _y = shop_draw_y_real_offset + cos(_rot * -1) * item_draw_radius
			
			//draw_sprite(spr_lemon_mask, 0, _inst.x + _x, _inst.y + _y);
			draw_set_color(#f0f0f0)
			draw_rectangle(_inst.x + _x - 1, _inst.y + _y - 1, _inst.x + _x + shop_draw_width + 1, _inst.y + _y + shop_draw_height + 1, false)
			draw_set_color(c_black)
			draw_rectangle(_inst.x + _x, _inst.y + _y, _inst.x + _x + shop_draw_width, _inst.y + _y + shop_draw_height, false)
			
			draw_string(shop_structs[(array_length(shop_items) - (item_draw_count - t) + shop_index) mod array_length(shop_items)].armor_name, _inst.x + _x + 1, _inst.y + _y + 3)
			_item_index = (array_length(shop_items) - (item_draw_count - t) + shop_index) mod array_length(shop_items)
		
			if(array_contains(global.settings.shop_items, _item_index) || global.shop_prices[_item_index] > global.player_data.metals)
				_text_type = "orange"
			else 
				_text_type = "normal"
			
			draw_string(shop_prices[_item_index], _inst.x + _x - 24, _inst.y + _y + 3, _text_type)
		}
		
		 _rot = ((shop_rot / shop_rot_time * shop_rot_dir) / item_draw_count) * (pi / 2) + pi / 2
		 _x = shop_draw_x_real_offset + sin(_rot * -1) * item_draw_radius
		 _y = shop_draw_y_real_offset + cos(_rot * -1) * item_draw_radius
			
		//center item
		draw_set_color(#f0f0f0)
		draw_rectangle(_inst.x + _x - 1, _inst.y + _y - 1, _inst.x + _x + shop_draw_width + 1, _inst.y + _y + shop_draw_height + 1, false)
		draw_set_color(#404048)
		draw_rectangle(_inst.x + _x, _inst.y + _y, _inst.x + _x + shop_draw_width, _inst.y + _y + shop_draw_height, false)
		draw_string(shop_structs[(shop_index) mod array_length(shop_items)].armor_name, _inst.x + _x + 1, _inst.y + _y + 3)
		
		_item_index = (shop_index) mod array_length(shop_items)
		
		if(array_contains(global.settings.shop_items, _item_index) || global.shop_prices[_item_index] > global.player_data.metals)
			_text_type = "orange"
		else 
			_text_type = "normal"
			
		draw_string(shop_prices[_item_index], _inst.x + _x - 24, _inst.y + _y + 3, _text_type)
		
		//description panel
		var _x = shop_draw_x_real_offset
		var _y = shop_draw_y_real_offset
		draw_set_color(c_white)
		draw_rectangle(_inst.x + _x + shop_draw_width - 1, _inst.y + _y - shop_draw_height - item_draw_radius - 1, _inst.x + _x + shop_draw_width + 80 + 1, _inst.y + _y + shop_draw_height + item_draw_radius + 1, false)
		draw_set_color(c_black)
		draw_rectangle(_inst.x + _x + shop_draw_width, _inst.y + _y - shop_draw_height - item_draw_radius, _inst.x + _x + shop_draw_width + 80, _inst.y + _y + shop_draw_height + item_draw_radius, false)
		
		//description text
		var _text = shop_structs[_item_index].description
		var _split_text = string_split(_text, " ")
		var _final_text = "";
		var _string_pos = 0;
		for(var g = 0; g < array_length(_split_text); g++){
			_final_text = ""
			while(string_get_text_length(_final_text) < 48){
				_final_text += " " + _split_text[g];
				g++;
			}
			g--;
			draw_string_condensed(_final_text, _inst.x + _x + shop_draw_width, _inst.y + _y - shop_draw_height - item_draw_radius + _string_pos * 10, "pause menu")
			_string_pos++;
		}
	}
	
	self.set_interacted_script(function(){
		with(obj_entity){
			if(variable_struct_exists(components, "__components"))
				array_foreach(components.__components, function(_comp){
					_comp.step_enabled = false;
				})
		}
		
		array_foreach(get_instance().components.__components, function(_comp){
			_comp.step_enabled = true;
		})
		
		shop_draw_x_real_offset = GAME_W;
	});
}