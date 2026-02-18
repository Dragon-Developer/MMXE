function ComponentStageSelector() : ComponentBase() constructor{
	self.selected = 2;
	
	self.reticle_sprite = undefined;
	
	self.stage_select_width = 5;
	self.stage_select_height = 4;
	
	self.stages = [
		{room: rm_explose_horneck, x: 19, y: 18, beat: false, icon: "undefined", music: "blast_hole_2.0", intro: "x", intro_text: "Explose Horneck Stage"},//'beat' will be replaced with save data info
		{room: rm_gate_2,          x: 67, y: 18, beat: false, icon: "gate", music: "intro_stage", intro: "gate", intro_text: "'cho ass is%fucked"},
		{room: rm_char_select,    x: 140, y: 11, beat: false, icon: "x", music: undefined, intro: "skip", intro_text: "you shouldnt see ths"},
		{room: rm_intro,           x: 213, y: 18, beat: false, icon: "undefined", music: "tutorial", intro: "x", intro_text: "Go learn the basics!"},
		{room: rm_horizontal_test, x: 261, y: 18, beat: false, icon: "undefined", music: "x2-intro-stage", intro: "zero", intro_text: "You can use full%color images for the%boss intro"},
	
		{room: rm_training_stage, x: 19, y: 182, beat: false, icon: "undefined", music: "blast_hole", intro: "x", intro_text: "A more fleshed out%level to see what%you can do in%the engine"},//'beat' will be replaced with save data info
		{room: rm_flame_stag, x: 67, y: 182, beat: false, icon: "undefined", music: "fame_stag", intro: "flame_stag", intro_text: "more of a joke%ngl"},
		{room: rm_headquarters, x: 140, y: 189, beat: false, icon: undefined, music: "HQ", intro: "x", intro_text: "go home and be%a family man!"},
		{room: rm_minimum_requirements, x: 213, y: 182, beat: false, icon: "undefined", music: "tutorial", intro: "x", intro_text: "not much of a stage%here. just needed%to fill out the%stage select"},
		{room: rm_test, x: 261, y: 182, beat: false, icon: "undefined", music: "WeaponGet", intro: "x", intro_text: "a whole lot of%nothing"}
	];//not much for the moment
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentPlayerInput();
		});
	}
	
	self.init = function(){
		global.checkpoint_id = undefined;
		self.stage_select_height = floor(array_length(self.stages) / self.stage_select_width);
		
		get(ComponentSpriteRenderer).character = "stage_select";
		get(ComponentSpriteRenderer).load_sprites();
		
		array_foreach(self.stages, function(_stage){
			if(_stage.icon != undefined)
				get(ComponentSpriteRenderer).add_sprite(_stage.icon, true, _stage.x, _stage.y)
		})
		
		get(ComponentSpriteRenderer).add_sprite("menu", true)
		
		log(working_directory)
		
		self.reticle_sprite = get(ComponentSpriteRenderer).add_sprite("reticle", true)
	}
	
	self.step = function(){
		if(input.get_input_pressed("up")){
			selected -= self.stage_select_width;
		} else if(input.get_input_pressed("down")){
			selected += self.stage_select_width;
		} else if(input.get_input_pressed("left")){
			selected -= 1;
		} else if(input.get_input_pressed("right")){
			selected += 1;
		} 
		
		if(input.get_input_pressed("jump")){
			global.stage_Data = self.stages[selected]
			//WORLD.stop_music();
			//WORLD.play_music(global.stage_Data.music)
			if(self.stages[selected].intro == "skip")
				room_transition_to(self.stages[selected].room,"standard", 20)
			else
				room_transition_to(rm_boss_intro,"standard", 30);
		}
		
		selected += self.stage_select_height * stage_select_width;
		selected = selected mod (self.stage_select_height * stage_select_width);
		
		get(ComponentSpriteRenderer).set_position(self.reticle_sprite, self.stages[selected].x - 2, self.stages[selected].y - 2)
	}
	
	/*
	
	this entity will only handle stage select. it will not handle armors or characters
	
	each stage select icon will be a child of this entity. this is to make animating easier
	
	*/
}