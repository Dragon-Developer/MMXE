function ComponentCutscene() : ComponentBase() constructor{
	self.actions = [];
	self.action_number = 0;
	self.delay = false
	self.has_done_first_action = false;
	
	self.init = function(){
	}
	
	self.step = function(){
		//log("pepis")
		
		if(self.action_number >= array_length(self.actions) - 1) {
			ENTITIES.destroy_instance(self.get_instance());
			return;
		}
		
		if(!has_done_first_action){
			if actions == [] return;
			else {
				self.actions[self.action_number].action();
				delay = true;
				has_done_first_action = true;
			}
			log("HERE I AM COME GET ME")
		}
		
		if(self.delay){
			self.delay = false
			return;
		}
		
		
		if(self.actions[self.action_number].criteria != camera_create_view)
			if(self.actions[self.action_number].criteria()){
				self.action_number++;
				delay = true;
				log("e")
				if(self.actions[self.action_number].action == undefined){
					log("undefined action!")
				} else {
					log("action exists yay")
				}
				log(self.actions[self.action_number].action);
				if(is_method(self.actions[self.action_number].action))
					self.actions[self.action_number].action(self.actions[self.action_number].arguments);
			}
	}
	
	self.set_cutscene = function(_actions){
		self.actions = _actions;
		self.action_number = 0;
	}
	
	self.add_cutscene_action = function(_action){
		array_push(self.actions, _action)
	}
	
	self.add_dialouge_part = function(_dialouge){
		var _inst = self.get_instance();
		var _dialogue = ENTITIES.create_instance(obj_dialouge);
		_dialogue.x = _inst.x;
		_dialogue.y = _inst.y;
		_dialogue.components.get(ComponentDialouge).set_dialouge(_dialouge, _dialouge[0].mugshot_left, _dialouge[0].mugshot_right);
		_dialogue.components.publish("change_dialouge",_dialouge);
		
		with(obj_player){
			components.get(ComponentPlayerMove).locked = true;
		}
	}
	
	self.have_player_move = function(_sequence){
		if(_sequence == undefined)
			log("there must be an error in transport")
		
		var _inst = self.get_instance();
		var _player = instance_nearest(_inst.x, _inst.y, obj_player);
		_player.components.get(ComponentPlayerInput).make_scripted_inputs_from_compressed(_sequence);
		log(_player.components.get(ComponentPlayerInput).scripted_input_index)
	}
	
	self.draw_gui = function(){
		if(self.action_number >= array_length(self.actions) - 1 || !global.debug) return;
		
		draw_string(self.action_number, 2, 2, "purple")
		if(self.actions[self.action_number].criteria != camera_create_view)
		draw_string(self.actions[self.action_number].criteria(), 2, 12, "purple")
	}
}