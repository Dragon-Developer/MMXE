function ComponentBossTease() : ComponentBase() constructor{
	self.title = room_get_name(global.stage_Data.room);
	self.description = global.stage_Data.intro_text
	
	self.init_time = CURRENT_FRAME;
	self.move_on_time = 1000;
	
	self.image_offset = 3;
	self.image_vertical_offset = 2;
	self.screen_offset = 160;
	self.lerping = 360;
	self.rate = 1.25;
	self.images = 4;
	
	self.init = function(){
		title = string_replace_all(title, "_", " ");
		if(string_char_at(title, 1) == "r" && string_char_at(title, 2) == "m" && string_char_at(title, 3) == " "){
			title = string_delete(title, 0, 3)
		}
		
		get(ComponentSpriteRenderer).character = "stage_intro";
		get(ComponentSpriteRenderer).subdirectories = ["/normal"];
		get(ComponentSpriteRenderer).load_sprites();
		
		//get(ComponentSpriteRenderer).add_sprite(_name, true, 48, 24 + i * 16)
		
		
		for(var p = 0; p < images; p++){
			var _col = make_color_rgb((p + 1) / images * 255, (p + 1) / images * 255, ((p + 1) / images * 255))
			get(ComponentSpriteRenderer).add_sprite(global.stage_Data.intro, false, screen_offset + 1 / ((CURRENT_FRAME - init_time) / lerping), 0, 1, 0, _col)
		}
	}
	
	self.step = function(){
		for(var p = 0; p < images; p++){
			var ip = images - p;
			get(ComponentSpriteRenderer).set_position(p + 1, screen_offset + 1 / clamp((CURRENT_FRAME - init_time) / lerping / (ip * rate), 0, 1) + ip * image_offset, ip * image_vertical_offset)
		}
		
		var _input = get(ComponentPlayerInput);
		
		if(CURRENT_FRAME - init_time > move_on_time || _input.get_input("jump") || _input.get_input("shoot") || _input.get_input("pause")){
			room_transition_to(global.stage_Data.room,"standard", 20)
		}
		
		//get(ComponentSpriteRenderer).set_position(_enemy.sprite, _enemy.position.x, _enemy.position.y)
	}
	
	self.draw = function(){
		draw_string(title, 48, 16);
		
		var _split = string_split(description, "%");
		
		array_foreach(_split, function(_obj, _ind){
			draw_string_condensed(_obj, 32, 48 + _ind * 12)
		})
		
		draw_string("press " + string(input_binding_get("jump")), 8, 226 + (move_on_time - (CURRENT_FRAME - init_time)) / 80)
	}
}