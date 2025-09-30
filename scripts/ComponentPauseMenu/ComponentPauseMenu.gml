function ComponentPauseMenu() : ComponentBase() constructor{
	/*
	
	Forte made this
	that's why its dogshit
	
	id be up to help explain it but i dont feel like it ):
	
	*/
	
	self.opacity = 0;
	self.opacity_rate = 1/5;
	
	self.weapon_names = [];
	self.weapon_descs = [];
	self.weapon_energies = [];
	self.weapon_selection = 0;
	
	self.tanks = [];//maybe you want a long list of sub tanks?
	self.tanks_selection = new Vec2(0,0);//we need to be able to scroll left and right in this menu!
	self.tanks_width = 2;//the width of tanks to display. 
	
	self.settings_selection = 0;
	self.player_art = -1;
	self.player = noone;
	
	self.palette = new Palette();
	
	self.input = noone;
	
	self.can_unpause = false;//to prevent immediately leaving the pause menu
	
	self.fsm = new SnowState("weapons", false)
	
	#region FSM
	self.fsm.add("weapons", {
			step: function(){
				self.weapon_selection += self.input.get_input_pressed_raw("down") - self.input.get_input_pressed_raw("up")
		
				self.weapon_selection = clamp(self.weapon_selection, 0, array_length(self.weapon_names) - 1)
				
				if(self.input.get_input_pressed_raw("down") - self.input.get_input_pressed_raw("up") != 0){
					var _wep = self.player.components.get(ComponentWeaponUse).change_weapon(self.weapon_selection);
					for(var i = 0; i < array_length(_wep); i++){
						palette.setPaletteColorByHex(i, _wep[i]);
					}
				}
			}
		})
		.add("settings", {
			step: function(){
				self.settings_selection += self.input.get_input_pressed_raw("down") - self.input.get_input_pressed_raw("up");
				self.settings_selection = clamp(self.settings_selection, 0, 2)
				
				if(self.input.get_input_pressed_raw("shoot") || self.input.get_input_pressed_raw("jump")) && self.settings_selection == 0{
					room_transition_to(rm_stage_select);
					ENTITIES.destroy_instance(self.get_instance())
				}
			}
		})
		.add("tanks", {
			step: function(){
				//self.weapon_selection += self.input.get_input_pressed_raw("down") - self.input.get_input_pressed_raw("up")
			}
		})
		.add_transition("t_transition", "weapons", "tanks", function(){return self.input.get_input_pressed_raw("right")})
		.add_transition("t_transition", "tanks", "weapons", function(){return self.input.get_input_pressed_raw("left")})
		.add_transition("t_transition", "tanks", "settings", function(){return self.input.get_input_pressed_raw("right")})
		.add_transition("t_transition", "settings", "tanks", function(){return self.input.get_input_pressed_raw("left")})
	#endregion
	
	self.init = function(){
		for(var i = 0; i < array_length(global.player_character.default_palette); i++){
			palette.setBaseColorByHex(i, global.player_character.default_palette[i]);
		}
		
		with(obj_player){
			if(components.get(ComponentPlayerInput).__player_index == global.local_player_index){
				components.get(ComponentPlayerInput).step_enabled = 1;
				other.input = components.get(ComponentPlayerInput);
				other.player = self;
			}
		}
		
		self.weapon_selection = self.player.components.get(ComponentWeaponUse).current_weapon[0]
		
		var _weaspon = self.player.components.get(ComponentWeaponUse).change_weapon(self.weapon_selection);
		for(var i = 0; i < array_length(_weaspon); i++){
			palette.setPaletteColorByHex(i, _weaspon[i]);
		}
		
		//spriteloader setup	
		get(ComponentSpriteRenderer).character = "pause";
		get(ComponentSpriteRenderer).load_sprites();
		get(ComponentSpriteRenderer).add_sprite("menu", true)
		for(var i = 0; i < array_length(global.player_character.weapons); i++){
			var _wep = {};
			
			with(_wep){
				script_execute(global.player_character.weapons[floor(i)]);
			}
			
			var _name = string(_wep.title);
			
			if(struct_exists(_wep, "description"))
				array_push(self.weapon_descs, _wep.description);
			else
				array_push(self.weapon_descs, "The " + _name);
			
			array_push(self.weapon_names, _name);
			array_push(self.weapon_energies, 28);
			
			_name = string_replace(_name, " ", "_")
			_name = string_replace(_name, ".", "")
			log(_name)
			
			if(i = 1)
				i += 0.5;
			
			get(ComponentSpriteRenderer).add_sprite(_name, true, 48, 24 + i * 16)
		}
		
		get_instance().x = 0;
		get_instance().y = 0;
		
		//tanks
		get(ComponentSpriteRenderer).add_sprite("sub_tank", true, 184, 176)
		get(ComponentSpriteRenderer).add_sprite("sub_tank", true, 184, 200)
		get(ComponentSpriteRenderer).add_sprite("weapon_tank", true, 224, 176)
		get(ComponentSpriteRenderer).add_sprite("weapon_tank", true, 224, 200)
		
		//settings bar
		get(ComponentSpriteRenderer).add_sprite("exit", true, 264, 160)
		get(ComponentSpriteRenderer).add_sprite("navigator", true, 264, 180)
		get(ComponentSpriteRenderer).add_sprite("settings", true, 264, 200)
	}
	
	self.step = function(){
		if(self.opacity < 1){
			self.opacity += self.opacity_rate;
			get(ComponentSpriteRenderer).sprites[0].animationController.__alpha = self.opacity;
		}
		
		if(!can_unpause){
			can_unpause = true;
			return;
		}
		
		self.fsm.trigger("t_transition");
		
		if (self.fsm.event_exists("step"))
			self.fsm.step();	
		
		if(self.input.get_input_pressed_raw("pause")){
			with(obj_entity){
				array_foreach(components.__components, function(_comp){
					_comp.step_enabled = true;
				})
			}
			
			ENTITIES.destroy_instance(self.get_instance());
		}
	}
	
	self.draw_gui = function(){
		
		var _damageable = player.components.get(ComponentDamageable);
		
		get(ComponentSpriteRenderer).draw_sprite("healthbar_icon_" + global.player_character.image_folder, 0,241,86)
		
		for(var p = 0; p < _damageable.health_max; p++){
			get(ComponentSpriteRenderer).draw_sprite("healthbar_tick", 0,241,84 - p * 2)
			if(p <= _damageable.health)
				get(ComponentSpriteRenderer).draw_sprite("healthbar_fill", 0,245,84 - p * 2)
		}
		
		get(ComponentSpriteRenderer).draw_sprite("healthbar_cap", 0,241,82 - _damageable.health_max * 2)
		
		for(var i = 0; i < array_length(self.weapon_names); i++){
			//add the notch between the other weapons and the buster
			if(i = 1)
				i += 0.5;
			
			//draw the name of the weapon
			draw_string(self.weapon_names[floor(i)], 72, 24 + i * 16, "pause menu")
			
			//draw the start of the ammo bar
			get(ComponentSpriteRenderer).draw_sprite("bar_start_cap", 0,72,32 + i * 16)
			//draw the ticks, change if its no longer full
			for(var q = 0; q < 28; q++){
				if(self.weapon_energies[floor(i)] >= q)
					get(ComponentSpriteRenderer).draw_sprite("bar_full_tick", 0,76 + q * 2,32 + i * 16)
				else
					get(ComponentSpriteRenderer).draw_sprite("bar_empty_tick", 0,76 + q * 2,32 + i * 16)
			}
			//draw the end of the ammo bar
			get(ComponentSpriteRenderer).draw_sprite("bar_end_cap", 0,76 + q * 2,32 + i * 16)
			
			//dim the icon if it isnt selected
			if(self.weapon_selection == floor(i)){
				get(ComponentSpriteRenderer).sprites[i + 1].animationController.__color = c_white;
			} else {
				get(ComponentSpriteRenderer).sprites[i + 1].animationController.__color = #a0a0a0;
			}
		}
		
		if(string_length(self.weapon_descs[self.weapon_selection]) > 15){
			draw_string(string_copy(self.weapon_descs[0], 0,15), 36, 204, "pause menu")
			draw_string(string_copy(self.weapon_descs[0],16,15), 36, 212, "pause menu")
		} else {
			draw_string(self.weapon_descs[self.weapon_selection], 36, 204, "pause menu")
		}
		
		//draw the tanks menu
		draw_string("E", 176, 176, "orange")
		draw_string("E", 176, 200, "orange")
		draw_string("W", 216, 176, "orange")
		draw_string("W", 216, 200, "orange")
		draw_string("TANKS", 168, 160, "orange")
		
		palette.apply();
		get(ComponentSpriteRenderer).draw_sprite(global.player_character.image_folder, 0, 160, 32);
		palette.reset();
	}
}