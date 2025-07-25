function ComponentStageSelector() : ComponentBase() constructor{
	self.selected = 0;
	
	self.stage_select_width = 2;
	self.stage_select_height = 4;
	
	self.stages = [
	{room: rm_explose_horneck, x: 32, y: 32, beat: false, icon: X_Mugshot_Angy1},//'beat' will be replaced with save data info
	{room: rm_gate_2, x: 64, y: 32, beat: false}];//not much for the moment
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
		});
	}
	
	self.init = function(){
		self.stage_select_height = array_length(self.stages) / self.stage_select_width;
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
		selected += self.stage_select_height * stage_select_width;
		selected = selected mod (self.stage_select_height * stage_select_width);
	}
	
	self.draw_gui = function(){
		array_foreach(self.stages, function(_stage){
			draw_sprite(_stage.icon, 0, _stage.x, _stage.y);
		});
		draw_sprite(spr_block, 0, self.stages[selected].x, self.stages[selected].y);
	}
	
	/*
	
	this entity will only handle stage select. it will not handle armors or characters
	
	each stage select icon will be a child of this entity. this is to make animating easier
	
	*/
}