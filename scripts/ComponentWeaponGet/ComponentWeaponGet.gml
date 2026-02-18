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
	self.player_sprite = noone;
	self.background = noone;
	self.white_fade_in_time = 45;
	self.flash_surface = surface_create(GAME_W, GAME_H);
	self.flash_speed = 19;
	self.show_weapon_time = 120;
	self.plr = noone;
	
	self.new_weapon = CursePinch;
	self.palette = noone;
	
	self.board_move_speed = 6;
	self.board_height = 32;
	
	self.init = function(){
		
		WORLD = ENTITIES.create_instance(obj_world);
		
		palette = new Palette();
		log(palette)
		self.renderer = get(ComponentSpriteRenderer);
		get(ComponentSpriteRenderer).character = "char_select";
		get(ComponentSpriteRenderer).subdirectories = [ "/normal", "/weapon_get"];
		get(ComponentSpriteRenderer).load_sprites();
		
		lines = get(ComponentSpriteRenderer).add_sprite("lines", 0, 0, 0);
		background = get(ComponentSpriteRenderer).add_sprite("weapon_get_background", 0, 0, 0);
		board = get(ComponentSpriteRenderer).add_sprite("weapon_get_board", 0, 0, GAME_H * -2);
		player_sprite = get(ComponentSpriteRenderer).add_sprite(global.player_character[0].image_folder, 0, 32, 0);
		
		var _wep = {};
		
		with(_wep){
			script_execute(other.new_weapon);
		}
		
		for(var i = 0; i < array_length(global.player_character[0].default_palette); i++){
			palette.setBaseColorByHex(i, global.player_character[0].default_palette[i]);
		}
		for(var i = 0; i < array_length(_wep.weapon_palette); i++){
			palette.setPaletteColorByHex(i, _wep.weapon_palette[i]);
		}
		log(palette)
		
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
			renderer.clear_sprite(player_sprite);
		}
	}
	
	self.white_flash = function(){
		var _wep = {};
		
		with(_wep){
			script_execute(other.new_weapon);
		}
		
		draw_string("YOU GOT",32,32);
		draw_string(_wep.title,48,40);
		
		surface_set_target(self.flash_surface);
		gpu_set_blendmode(bm_subtract);
		draw_clear_alpha(c_white,1)
		
		draw_circle(GAME_W * 2 / 3, GAME_H / 2,(CURRENT_FRAME - self.timer) * self.flash_speed,false);
		
		gpu_set_blendmode(bm_normal);
		surface_reset_target();
		
		draw_surface(self.flash_surface,0,0)
		
		if(self.timer + (GAME_W / self.flash_speed) <= CURRENT_FRAME){
			self.state = "show_weapon"
			self.timer = CURRENT_FRAME + show_weapon_time;
			
		}
		
		palette.apply();
		renderer.draw_sprite(global.player_character[0].image_folder, 0, 32, 0);
		palette.reset();
	}
	
	self.show_weapon = function(){
		var _wep = {};
		
		with(_wep){
			script_execute(other.new_weapon);
		}
		
		draw_string("YOU GOT",32,32);
		draw_string(_wep.title,48,40);
		
		palette.apply();
		renderer.draw_sprite(global.player_character[0].image_folder, 0, 32, 0);
		palette.reset();
		
		if(self.timer == CURRENT_FRAME){
			self.state = "card_raise"
			self.timer = CURRENT_FRAME
		}
	}
	
	self.card_raise = function(){
		
		
		palette.apply();
		renderer.draw_sprite(global.player_character[0].image_folder, 0, 32, 0);
		palette.reset();
		
		var _board_pos = renderer.get_position(board);
		
		renderer.set_position(board,_board_pos.x,_board_pos.y - board_move_speed);
		
		if(_board_pos.y <= GAME_W * -0.6){
			renderer.clear_sprite(board);
			board = get(ComponentSpriteRenderer).add_sprite("weapon_get_board", 0, 0, GAME_H * -1.2);
			self.state = "card_lower"
			self.timer = CURRENT_FRAME
		} else if(_board_pos.y >= GAME_W * -0.5){
			var _wep = {};
		
			with(_wep){
				script_execute(other.new_weapon);
			}
		
			draw_string("YOU GOT",32,32 - (CURRENT_FRAME - self.timer) * 3);
			draw_string(_wep.title,48,40 - (CURRENT_FRAME - self.timer) * 3);
		}
	}
	
	self.card_lower = function(){
		palette.apply();
		renderer.draw_sprite(global.player_character[0].image_folder, 0, 32 + (CURRENT_FRAME - self.timer) * board_move_speed, 0);
		palette.reset();
		
		var _board_pos = renderer.get_position(board);
		
		renderer.set_position(board,_board_pos.x,_board_pos.y + board_move_speed);
		renderer.draw_sprite("weapon_get_board", 0,_board_pos.x,_board_pos.y);
		
		if(_board_pos.y >= board_height){
			//renderer.sprites = [];
			//renderer.init();
			self.state = "player_test";
			//the following is bad practice in this engine, but i would
			//like to get all of the updates the player spawn gets so ill
			//just make the player spawn lol
		
			plr = ENTITIES.create_instance(obj_player,48,192)
			self.spawn_player(plr);
			plr.components.get(ComponentWeaponUse).set_weapons([new_weapon]);
			plr.components.get(ComponentWeaponUse).change_weapon(0);
		}
	}
	
	self.player_test = function(){
	}
	
	self.spawn_player = function(_player){
		self.get_instance().depth += 100;
		_player.components.get(ComponentAnimationShadered).set_subdirectories(
		[ "/normal"]);
		_player.components.get(ComponentPlayerInput).set_player_index(0);
		_player.components.publish("character_set", global.player_character[0].image_folder);
		//log(string(global.player_character.image_folder) + " is the character folder")
	//	log(string(global.player_character) + " is the character")
		_player.components.publish("armor_set",
		[ "x1_helm","x1_body","x1_arms","x1_legs" ]);
	
		//create the charge graphics and make it a child
	
		var _charge = ENTITIES.create_instance(obj_charge);
		_charge.depth = _player.depth - 1;
		_charge.components.publish("character_set", "player");
		_player.components.get(ComponentNode).add_child(_charge.components.get(ComponentNode));
		_player.components.get(ComponentWeaponUse).set_weapons(new_weapon);
		_player.components.get(ComponentWeaponUse).weapon_ammo_max = global.player_character[0].weapon_ammo_max;
		_player.components.get(ComponentWeaponUse).weapon_ammo = array_create(1, 1024);
		//
		//set health to not 1
		_player.components.get(ComponentDamageable).set_health(global.player_data.health,global.player_data.max_health);
		_player.components.get(ComponentDamageable).invuln_time = 120;
	
		if(global.server_settings.client_data.friendly_fire){
			_player.components.get(ComponentDamageable).projectile_tags = ["player" + string(0)]
		}
	
		with(_player.components.get(ComponentDamageable)){
			self.death_function = function(){
				self.publish("death");
			}
		}
	
		log(global.armors[0])
	
		_player.components.get(ComponentPlayerMove).apply_full_armor_set(global.armors[0]);
	
		_player.components.get(ComponentPlayerInput).__BufferLength = 0;
		_player.components.get(ComponentPlayerInput).buffer_reset();
	}
}