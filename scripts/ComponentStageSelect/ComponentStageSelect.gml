function ComponentStageSelector() : ComponentBase() constructor{
	self.selected = 0;
	self.spriteDrawer = undefined;
	
	self.menu_sprite = undefined;
	
	self.stage_select_width = 5;
	self.stage_select_height = 4;
	
	self.stages = [
	{room: rm_explose_horneck, x: 19, y: 18, beat: false, icon: spr_undefined, music: "blast_hole_2.0"},//'beat' will be replaced with save data info
	{room: rm_gate_2, x: 67, y: 18, beat: false, icon: gate_mugshot_quickine, music: "intro_stage"},
	{room: rm_headquarters, x: 140, y: 11, beat: false, icon: Sprite20, music: "HQ"},
	{room: rm_intro, x: 213, y: 18, beat: false, icon: X_Mugshot1, music: "tutorial"},
	{room: rm_metroid, x: 261, y: 18, beat: false, icon: spr_undefined, music: "HQ"},
	
	{room: rm_horizontal_test, x: 19, y: 182, beat: false, icon: spr_undefined, music: "blast_hole_2.0"},//'beat' will be replaced with save data info
	{room: rm_test, x: 67, y: 182, beat: false, icon: gate_mugshot_quickine, music: "intro_stage"},
	{room: rm_char_select, x: 140, y: 189, beat: false, icon: Sprite20, music: undefined},
	{room: rm_intro, x: 213, y: 182, beat: false, icon: X_Mugshot1, music: "tutorial"},
	{room: rm_metroid, x: 261, y: 182, beat: false, icon: spr_undefined, music: "HQ"}
	];//not much for the moment
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentPlayerInput();
		});
	}
	
	self.init = function(){
		self.stage_select_height = floor(array_length(self.stages) / self.stage_select_width);
		spriteDrawer = self.get_instance().components.get(ComponentSpriteDrawer);
		spriteDrawer.directory = "stage_select/"
		spriteDrawer.load_sprites();
		spriteDrawer.add_sprites_to_storage(["menu"]);
		self.menu_sprite = spriteDrawer.get_sprite("menu")
		//WORLD.play_music("StageSelect")
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
			room_goto(self.stages[selected].room)
			ENTITIES.destroy_instance(self.get_instance())
		}
		
		selected += self.stage_select_height * stage_select_width;
		selected = selected mod (self.stage_select_height * stage_select_width);
	}
	
	self.draw = function(){
		array_foreach(self.stages, function(_stage){draw_sprite(_stage.icon, 0, _stage.x, _stage.y)})
		draw_sprite(spr_stage_select_menu, 0, 0, 0);
		draw_sprite(spr_bar1_area, 0, self.stages[self.selected].x, self.stages[self.selected].y)
	}
	
	/*
	
	this entity will only handle stage select. it will not handle armors or characters
	
	each stage select icon will be a child of this entity. this is to make animating easier
	
	*/
}