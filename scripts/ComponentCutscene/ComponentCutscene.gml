function ComponentCutscene() : ComponentBase() constructor{
	self.actions = [];
	self.continue_functions = [];
	self.action_number = 0;
	
	self.init = function(){
		with(obj_player){
			components.get(ComponentPlayerMove).locked = true;
			components.get(ComponentPlayerMove).fsm.trigger("t_dialouge");
		}
	}
	
	self.step = function(){
		if(self.action_number > array_length(self.actions)) ENTITIES.destroy_instance(self.get_instance());
		
		if(self.continue_functions[self.action_number]()){
			self.action_number++;
			self.actions[self.action_number]();
		}
	}
	
	self.set_cutscene = function(_actions, _clauses){
		self.actions = _actions;
		self.continue_functions = _clauses;
		self.action_number = 0;
	}
	
	self.add_dialouge_part = function(_dialouge){
		array_push(self.actions, function(){
			var _inst = self.get_instance();
			var _dialogue = ENTITIES.create_instance(obj_dialouge);
			_dialogue.x = _inst.x;
			_dialogue.y = _inst.y;
			_dialogue.components.get(ComponentDialouge).set_dialouge(_dialouge, _dialouge[0].mugshot_left, _dialouge[0].mugshot_right);
			_dialogue.components.publish("change_dialouge",_dialouge);
		});
		
		array_push(self.continue_functions, function(){return !instance_exists(obj_dialouge);});
	}
	
	self.have_player_move = function(_sequence){
		array_push(self.actions, function(){
			var _inst = self.get_instance();
			var _player = instance_nearest(_inst.x, _inst.y, obj_player);
			_player.components.get(ComponentPlayerInput).scripted_inputs = _sequence;
			_player.components.get(ComponentPlayerInput).using_scripted_inputs = true;
			_player.components.get(ComponentPlayerInput).scripted_input_index = 0;
		});
		
		array_push(self.continue_functions, function(){return !instance_exists(obj_dialouge);});
	}
}