function ComponentArmorSelect() : ComponentBase() constructor{
	self.possible_armors = global.player_character[0].possible_armors
	
	self.selected_part = 0;
	
	array_copy(
	possible_armors,0,
	global.player_character[0].possible_armors,0,5)
	self.selected_armor = global.armors[0];
	
	//nested for loop so i can check what the armors actual id is
	for(var e = 0; e < array_length(self.selected_armor);e++){
		for(var q = 0; q < array_length(self.possible_armors[e]);q++){
			if(self.possible_armors[e][q] == self.selected_armor[e]){
				//self.selected_armor[e] = q;
				continue;
			}
		}
	}
	
	log(self.selected_armor)
	
	self.armor_sprites = [];
	
	self.button_pos = [
		new Vec2(34,18),
		new Vec2(18,50),
		new Vec2(26,82),
		new Vec2(10,114),
		new Vec2(18,154),
		new Vec2(10,202),
		new Vec2(282,170),
		new Vec2(282,202)
	];
	
	self.renderer = noone;
	
	self.line_rate = 0;
	self.points_of_interest = [
		new Vec2(112,40),
		new Vec2(64, 64),
		new Vec2(128,88),
		new Vec2(72,136),
		new Vec2(136,84)
	]
	
	self.init = function(){
		var _inst = self.get_instance();
		_inst.x = 0;
		_inst.y = 0;
		
		self.renderer = get(ComponentSpriteRenderer);
		get(ComponentSpriteRenderer).character = "char_select";
		get(ComponentSpriteRenderer).subdirectories = [ "/normal", "/armor_select"];
		get(ComponentSpriteRenderer).load_sprites();
		self.character_art = get(ComponentSpriteRenderer).add_sprite(global.player_character[0].image_folder, true)
		
		get(ComponentSpriteRenderer).add_sprite("head_part", true,button_pos[0].x,button_pos[0].y)
		get(ComponentSpriteRenderer).add_sprite("arms_part", true,button_pos[1].x,button_pos[1].y)
		get(ComponentSpriteRenderer).add_sprite("body_part", true,button_pos[2].x,button_pos[2].y)
		get(ComponentSpriteRenderer).add_sprite("boot_part", true,button_pos[3].x,button_pos[3].y)
		get(ComponentSpriteRenderer).add_sprite("full_armor",true,button_pos[4].x,button_pos[4].y)
		get(ComponentSpriteRenderer).add_sprite("presets",   true,button_pos[5].x,button_pos[5].y)
		get(ComponentSpriteRenderer).add_sprite("confirm",   true,button_pos[6].x,button_pos[6].y)
		get(ComponentSpriteRenderer).add_sprite("cancel",    true,button_pos[7].x,button_pos[7].y)
		
		array_foreach(self.possible_armors, function(){
			array_push(self.armor_sprites, get(ComponentSpriteRenderer).add_sprite("noone", true))
		})
		
		self.change_armor(0, true);
		self.selected_part++;
		self.change_armor(0, true);
		self.selected_part++;
		self.change_armor(0, true);
		self.selected_part++;
		self.change_armor(0, true);
		self.selected_part++;
		
		self.selected_part = 0;
	}
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentPlayerInput();
		});
	}
	
	self.step = function(){
		
		//left and right movement - change which armor the part is from
		var _change = self.input.get_input_pressed("right") - self.input.get_input_pressed("left")
		
		if(self.selected_part <= 4){
			self.change_armor(_change);
		} else if(_change != 0){
			if(selected_part > 5)
				self.selected_part = 5;
			else 
				self.selected_part = 6;
		}
		
		//up and down - change which part we are changing
		//its inverted as the higher the point of the array we are in the lower we are onscreen
		_change = self.input.get_input_pressed("down") - self.input.get_input_pressed("up")
		
		if(_change != 0){
			//if the selected part is less than 5, then we are selecting one of the armor segments or the 
			if(self.selected_part <= 5){
			self.selected_part = clamp(self.selected_part + _change,0, 256);
			
			self.selected_part = (self.selected_part + array_length(self.selected_armor) + 1) mod (array_length(self.selected_armor) + 1);
			} else if(self.selected_part == 6){
				self.selected_part = 7;
			}else if(self.selected_part == 7){
				self.selected_part = 6;
			}
			//if the selected part is over 7 you done fucked up
		}
		
		if(self.input.get_input_pressed("jump") && self.selected_part == 7){
			room_transition_to(rm_char_select,"default",20);
		}
		if(self.input.get_input_pressed_raw("jump") && self.selected_part == 6){
			room_transition_to(rm_char_select,"default",20);
			
			var _ret = array_create(array_length(self.selected_armor))
			
			for(var p = 0; p < array_length(self.selected_armor); p++){
				_ret[p] = self.selected_armor[p]
			}
			
			global.armors[global.character_index] = _ret;
			
			struct_set(global.player_data, "last_used_armor", global.armors);
			self.step = function(){};
		}
	}
	
	self.change_armor = function(_change, _force = false){
		if(_change != 0 || _force){
			//increment the armor part by 1
			log(self.selected_armor)
			self.selected_armor[self.selected_part]+= _change;
			
			
			self.selected_armor[self.selected_part] = 
					(self.selected_armor[self.selected_part] + 
						array_length(self.possible_armors[self.selected_part]) )
				mod 
					array_length(self.possible_armors[self.selected_part])
					
					log(array_length(self.possible_armors[self.selected_part]))
			
			//get the sprite name so it can be rendered properly
			var _armor = {};
			
			var _code = self.possible_armors[
							self.selected_part]
							[self.selected_armor[
								self.selected_part
							]
						]
			//if the armor exists, get the sprite of it
			if(_code != noone){
				with(_armor){
					script_execute(_code)
				}
			
				var _sprite_name = _armor.sprite_name;
				_sprite_name = string_delete(_sprite_name, 0, 1);
				_sprite_name = string_replace(_sprite_name, "/", "_");
				
				_sprite_name = global.player_character[0].image_folder + "_" + _sprite_name;
			
				get(ComponentSpriteRenderer).change_sprite(self.armor_sprites[self.selected_part], _sprite_name)
			} else {
				//otherwise just load nothing
				get(ComponentSpriteRenderer).change_sprite(self.armor_sprites[self.selected_part], "nothing")
			}
		}
	}
	
	self.draw = function(){
		draw_sprite(spr_reticle_armor_select,0,button_pos[self.selected_part].x - 2,button_pos[self.selected_part].y - 2)
	}
	
	self.draw_gui = function(){
		if(self.selected_part >= 5) return;
		draw_set_color(c_white)
		//draw_line_width(0,0,GAME_W,GAME_H,3)
		draw_line_percentage(
		button_pos[self.selected_part].x + 20,button_pos[self.selected_part].y + 10,
		points_of_interest[self.selected_part].x,points_of_interest[self.selected_part].y,
		3,line_rate/100)
		
		line_rate = clamp(line_rate++,0,100)
	}
}