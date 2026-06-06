function ComponentStageSelector() : ComponentBase() constructor{
	self.selected = 2;
	
	self.reticle_sprite = undefined;
	
	self.stage_select_width = 5;
	self.stage_select_height = 4;
	self.fortressing = true;
	
	self.stages = [//the delimiter is % a delimiter means that's where the string is split at
		new Stage_Select_icon_generate(rm_explose_horneck, 19, 18, "undefined", "blast_hole_2.0", "x", "Explose Horneck%Stage", 5, 5, 4, 1),
		new Stage_Select_icon_generate(rm_gate_2, 67, 18, "gate", "intro_stage", "gate", "Peak", 6, 6, 0, 2),
		new Stage_Select_icon_generate(rm_char_select, 140, 11, "x", undefined, "x", "Swap out your%character", 7, 7, 1, 3),
		new Stage_Select_icon_generate(rm_intro, 213, 18, "undefined", "tutorial", "x", "Go learn the%basics!", 8, 8, 2, 4),
		new Stage_Select_icon_generate(rm_much_less_chill_penguin, 261, 18, "chill", "volcano_rage", "chill", "An old maverick%returns, destroying%old hunter bases!", 9, 9, 3, 0),
		
		new Stage_Select_icon_generate(rm_training_stage, 19, 182, "undefined", "blast_hole", "x", "Rougher than%the rest of%'em!", 0, 0, 9, 6),
		new Stage_Select_icon_generate(rm_flame_stag, 67, 182, "undefined", "flame_stag", "flame_stag", "Less scary%without the%lava", 1, 1, 5, 7),
		new Stage_Select_icon_generate(rm_headquarters, 140, 189, "undefined", "HQ", "x", "Go home and be%a family man!", 2, 2, 6, 8),
		new Stage_Select_icon_generate(rm_simple, 213, 182, "undefined", "tutorial", "x", "Super simple%stage", 3, 3, 7, 9, new ChillPenguinStageReward()),
		new Stage_Select_icon_generate(rm_dynamos_hellhole, 261, 182, "undefined", "WeaponGet", "x", "Dynamo set up%an amusement%park?!?!% %Go investigate%the park!", 4, 4, 8, 0)
	];//not much for the moment
	
	self.fortress_stages = [
		new Stage_Select_icon_generate(rm_fortress_1, 0, 79, "fortress", "blast_hole", "sigma", "There's a computer%virus in the%real world?%%Delete the virus!", 0, 5, 10, 10),
		new Stage_Select_icon_generate(rm_fortress_2, 0, 79, "fortress_2", "blast_hole", "sigma", "There's a computer%virus in the%real world?%%Delete the virus!", 0, 5, 10, 10),
		new Stage_Select_icon_generate(rm_fortress_3, 0, 79, "fortress_3", "blast_hole", "sigma", "There's a computer%virus in the%real world?%%Delete the virus!", 0, 5, 10, 10),
		new Stage_Select_icon_generate(rm_fortress_4, 0, 79, "fortress_4", "blast_hole", "sigma", "There's a computer%virus in the%real world?%%Delete the virus!", 0, 5, 10, 10)
	]
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentPlayerInput();
		});
	}
	
	self.init = function(){
		log(fortress_stages[0])
		
		global.return_stage = rm_stage_select;
		var _complete = [false, false, false, false, false, false, false, false, false, false];
		for(var w = 0; w < array_length(stages); w++){
			if(variable_struct_exists(global.player_data.beaten_stages, room_get_name(stages[w].rm))){
				_complete[w] = true
			}
		}
		
		log(_complete)
		log(global.player_data.beaten_stages)
		
		if(_complete[0] && _complete[1] && _complete[3] && _complete[4] && _complete[5] && _complete[6] && _complete[8] && _complete[9]){
			if !global.player_data.seen_fortress_cutscene{
				room_goto(rm_fortress_cutscene);
				global.player_data.seen_fortress_cutscene = true;
				log("bepis")
				return;
			}
			
			log("FORTRESS TIME")
			if(variable_struct_exists(global.player_data.beaten_stages, room_get_name(self.fortress_stages[2].rm)))
				array_push(self.stages, self.fortress_stages[3])
			else if(variable_struct_exists(global.player_data.beaten_stages, room_get_name(self.fortress_stages[1].rm)))
				array_push(self.stages, self.fortress_stages[2])
			else if(variable_struct_exists(global.player_data.beaten_stages, room_get_name(self.fortress_stages[0].rm)))
				array_push(self.stages, self.fortress_stages[1])
			else 
				array_push(self.stages, self.fortress_stages[0])
				
			self.stages[0].down = 10;
			self.stages[5].up = 10;
				
			fortressing = true;
		}
		
			global_prepare_application(MENU_W, MENU_H)
		global.checkpoint_id = undefined;
		self.stage_select_height = floor(array_length(self.stages) / self.stage_select_width);
		
		if(fortressing){
			stage_select_height++;
		}
		
		get(ComponentSpriteRenderer).character = "stage_select";
		get(ComponentSpriteRenderer).load_sprites();
		get(ComponentSpriteRenderer).add_sprite("menu", false)
		
		array_foreach(self.stages, function(_stage){
			if(_stage.icon != undefined)
				get(ComponentSpriteRenderer).add_sprite(_stage.icon, false, _stage.x, _stage.y)
		})
		
		
		log(working_directory)
		
		self.reticle_sprite = get(ComponentSpriteRenderer).add_sprite("reticle", false)
	}
	
	self.step = function(){
		if(input.get_input_pressed("up")){
			selected = self.stages[selected].up
		} else if(input.get_input_pressed("down")){
			selected = self.stages[selected].down
		} else if(input.get_input_pressed("left")){
			selected = self.stages[selected].left
		} else if(input.get_input_pressed("right")){
			selected = self.stages[selected].right
		} 
		
		if(input.get_input_pressed("jump")){
			global.stage_Data = self.stages[selected]
			//WORLD.stop_music();
			//WORLD.play_music(global.stage_Data.music)
			if(self.stages[selected].intro == "skip")
				room_transition_to(self.stages[selected].rm,"standard", 20)
			else
				room_transition_to(rm_boss_intro,"standard", 30);
		}
		
		get(ComponentSpriteRenderer).set_position(self.reticle_sprite, self.stages[selected].x - 2, self.stages[selected].y - 2)
	}
	
	self.draw_gui = function(){
		var title = string_replace_all(room_get_name(stages[selected].rm), "_", " ");
		if(string_char_at(title, 1) == "r" && string_char_at(title, 2) == "m" && string_char_at(title, 3) == " "){
			title = string_delete(title, 0, 3)
		}
		draw_string_condensed(title, 70, 80)
		
		var _split = string_split(stages[selected].intro_text, "%");
		
		array_foreach(_split, function(_obj, _ind){
			draw_string_condensed(_obj, 70, 100 + _ind * 10)
		})
	}
	
	/*
	
	this entity will only handle stage select. it will not handle armors or characters
	
	each stage select icon will be a child of this entity. this is to make animating easier
	
	*/
}