function ComponentWeaponGet() : ComponentBase() constructor{
	/*
	
	states:
	fade in
	white fade
	white flash
	show weapon
	card raise
	card lower
	player test
	
	*/
	
	self.state = "fade_in"//we dont need snowstate here. its easier to do it rough and simple
	self.timer = CURRENT_FRAME + 60;
	self.board = noone;
	self.lines = noone;
	self.white_fade_in_time = 50;
	self.flash_surface = surface_create(GAME_W, GAME_H);
	self.flash_speed = 20;
	self.show_weapon_time = 90;
	
	self.new_weapon = new CursePinch();
	self.palette = noone;
	
	self.init = function(){
		palette = new Palette();
		self.renderer = get(ComponentSpriteRenderer);
		get(ComponentSpriteRenderer).character = "char_select";
		get(ComponentSpriteRenderer).subdirectories = [ "/normal", "/weapon_get"];
		get(ComponentSpriteRenderer).load_sprites();
		
		lines = get(ComponentSpriteRenderer).add_sprite("lines", 0, 0, 0);
		get(ComponentSpriteRenderer).add_sprite("weapon_get_background", 0, 0, 0);
		board = get(ComponentSpriteRenderer).add_sprite("weapon_get_board", 0, 0, GAME_H * -2);
		get(ComponentSpriteRenderer).add_sprite(global.player_character[0].image_folder, 0, 32, 0);
		
		for(var i = 0; i < array_length(global.player_character[0].default_palette); i++){
			Palette.setBaseColorByHex(i, global.player_character[0].default_palette[i]);
		}
		for(var i = 0; i < array_length(self.new_weapon.weapon_palette); i++){
			Palette.setPaletteColorByHex(i, self.new_weapon.weapon_palette[i]);
		}
		
		log("SETUPED")
	}
	
	self.draw_gui = function(){
		
		self.renderer.set_position(self.lines, 0, 15 - (CURRENT_FRAME mod 80))
		switch(self.state){
			default:
			
			break;
			case("fade_in"):
				self.fade_in();
			break;
			case("white_fade"):
				self.white_fade();
			break;
			case("white_flash"):
				self.white_flash();
			break;
			case("show_weapon"):
				self.show_weapon();
			break;
			case("card_raise"):
				self.card_raise();
			break;
			case("card_lower"):
				self.card_lower();
			break;
			case("player_test"):
				self.player_test();
			break;
			case("leave"):
				room_transition_to(rm_stage_select)
			break;
			
		}
	}
	
	self.fade_in = function(){
		if(self.timer == CURRENT_FRAME){
			self.state = "white_fade"
			self.timer += white_fade_in_time;
		}
	}
	
	self.white_fade = function(){
		draw_sprite_ext(spr_bright, 0,0,0,1,1,0,c_white,(CURRENT_FRAME - self.timer + self.white_fade_in_time) / self.white_fade_in_time);
		renderer.draw_sprite("x_glow",0, 32,0);
		if(self.timer == CURRENT_FRAME){
			self.state = "white_flash"
			self.renderer.set_position(self.board,0,0)
			
			for(var i = 0; i < array_length(global.player_character[0].default_palette); i++){
				Palette.setBaseColorByHex(i, global.player_character[0].default_palette[i]);
			}
			for(var i = 0; i < array_length(self.new_weapon.weapon_palette); i++){
				Palette.setPaletteColorByHex(i, self.new_weapon.weapon_palette[i]);
			}
		}
	}
	
	self.white_flash = function(){
		surface_set_target(self.flash_surface);
		gpu_set_blendmode(bm_subtract);
		draw_clear_alpha(c_white,1)
		
		draw_circle(GAME_W * 2 / 3, GAME_H / 2,(CURRENT_FRAME - self.timer) * self.flash_speed,false);
		
		gpu_set_blendmode(bm_normal);
		surface_reset_target();
		
		draw_surface(self.flash_surface,0,0)
		
		if(self.timer + (GAME_W / self.flash_speed) == CURRENT_FRAME){
			self.state = "show_weapon"
			self.timer = CURRENT_FRAME + show_weapon_time;
			
		}
		
		palette.apply();
		renderer.draw_sprite(global.player_character[0].image_folder, 0, 32, 0);
		palette.reset();
	}
	
	self.show_weapon = function(){
		draw_string("YOU GOT",32,32);
		draw_string(new_weapon.title,48,40);
		
		palette.apply();
		renderer.draw_sprite(global.player_character[0].image_folder, 0, 32, 0);
		palette.reset();
	}
	
	self.card_raise = function(){
		
	}
	
	self.card_lower = function(){
		
	}
	
	self.player_test = function(){
		
	}
}