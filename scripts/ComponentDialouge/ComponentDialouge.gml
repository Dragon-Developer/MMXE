function ComponentDialouge() : ComponentBase() constructor{
	var _dia = {   sentence : "NOP this no work",
		mugshot_left : "x",
		mugshot_right : "x",
		focus : "right"
	}
	self.chat = [_dia];
	self.point_in_chat = 0;
	self.current_text = "dummy";
	self.left_mugshot = noone;
	self.right_mugshot = noone;//there IS a way to auto generate sprites!
	self.focus = "right";
	self.dialouge_startup = 24;// this number will slowly drop until forte makes it instant
	self.dialouge_start_time = CURRENT_FRAME + dialouge_startup;
	self.text_chunks = ["Component Error!"];//i need to split text up so the words dont trail off
	self.tc_length = [32];//cache these values instead of regenerating them every frame. the text doesnt change mid sentence.
	self.text_length = [32];
	self.completed_text = false;
	self.input = noone;
	
	self.animation_index = 0;//a timer for a thing. 
	
	self.dialouge_box_width = 192;//not including mugshots. those are tacked onto the side.
	self.dialouge_margin = 2;//the distance between the edge of the textbox and the text
	self.dialouge_y_top = 16;
	self.dialouge_y_height = 44;
	
	self.option_x_offset = 20;
	
	self.options = [];
	self.option_functions = [];
	self.selected_option = 0;
	
	self.init = function(){
		get(ComponentSpriteRenderer).character = "dialouge";
		get(ComponentSpriteRenderer).load_sprites();
		
		self.left_mugshot_sprite = get(ComponentSpriteRenderer).add_sprite("x", true, GAME_W / 2 + self.dialouge_box_width / 2 + self.dialouge_margin + 22, dialouge_y_top + 22, -1)
		//                                                              (_animation = "idle", _on_gui_layer = false, _x = 0, _y = 0, _dir = 1, _depth = 0, _color = c_white)
		self.right_mugshot_sprite  = get(ComponentSpriteRenderer).add_sprite("x", true, GAME_W / 2 - self.dialouge_box_width / 2 - self.dialouge_margin - 22, dialouge_y_top + 22)
		
		
		
		self.set_dialouge_with_enum(self.chat[0]);
	}
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
		});
		self.subscribe("change_dialouge", function(_chat) {
			self.chat = _chat;
			self.set_dialouge_with_enum(self.chat[0]);
		});
	}
	
	self.set_dialouge_with_enum = function(_dialouge){
		//log(_dialouge)
		self.set_dialouge(_dialouge.sentence, _dialouge.mugshot_left, _dialouge.mugshot_right, _dialouge.focus);
	}
	
	self.set_dialouge = function(_text, _mugshot_left = "x", _mugshot_right = "x", _focus = "right"){
		
		
		self.text_chunks = [];
		self.tc_length = [];
		self.text_length = [];
		
		if(is_array(_text)){
			self.chat = _text;
			_text = _text[0].sentence
		}
		
		if(_text == -4){
			log("something done fucked up")
		}
		
		var _convo_array = string_split(_text," ");
		var _cv_length = 0;
		var _cv_offset = 0;
		var _tmp_wrd = "";
		
		while(_cv_offset < array_length(_convo_array)){
			
			_tmp_wrd = "";
			
			while(string_get_text_length(_tmp_wrd + " " + _convo_array[clamp(_cv_length + _cv_offset,0, array_length(_convo_array) - 1)]) < self.dialouge_box_width){
				_tmp_wrd += " ";
				if(clamp(_cv_length + _cv_offset,0, array_length(_convo_array) - 1) != _cv_length + _cv_offset) break;
				_tmp_wrd += _convo_array[clamp(_cv_length + _cv_offset,0, array_length(_convo_array) - 1)];
				_cv_length++;
			}
			
			_cv_offset += _cv_length;
			_cv_length = 0;
			array_push(self.text_chunks,_tmp_wrd);
			array_push(self.tc_length, string_length(_tmp_wrd));
			array_push(self.text_length,0);
		}
		self.current_text = _text;//this may be removed. this is not useful outside of getting what part
		//of the conversation you are in
		self.text_max_length = string_get_text_length(_text);
		self.right_mugshot = _mugshot_left;
		self.left_mugshot = _mugshot_right;
		self.focus = _focus;
		//return _text;
		
		//get sprite names ready
		var _sprite_name_left = string(_mugshot_left);
		var _sprite_name_right = string(_mugshot_right);
		
		
		//apply talking if relevant
		if(string_lower(focus) == "left")
			_sprite_name_left += "_talking"
		else 
			_sprite_name_right += "_talking"
			
		log(_sprite_name_right)
			
		get(ComponentSpriteRenderer).change_sprite(self.left_mugshot_sprite, _sprite_name_right)
		get(ComponentSpriteRenderer).change_sprite(self.right_mugshot_sprite, _sprite_name_left)
		get(ComponentSpriteRenderer).sprites[self.right_mugshot_sprite].animationController.__xscale = -1;
	};
	
	self.step = function(){
		if(self.input.get_input_pressed_raw("jump") && self.dialouge_start_time < CURRENT_FRAME){
			if(self.text_length[array_length(self.text_length) - 1] != self.tc_length[array_length(self.text_length) - 1]){
				self.text_length = self.tc_length;
			}else{
				
				if(variable_struct_exists(self.chat[self.point_in_chat], "option_1")){
					
					if(is_method(self.option_functions[self.selected_option]))
						script_execute(self.option_functions[self.selected_option])
					self.selected_option = 0;
				}
				
				self.point_in_chat++;
				if(self.point_in_chat >= array_length(self.chat)){
					ENTITIES.destroy_instance(self.get_instance());
					instance_destroy(self.get_instance())
				} else	{
					self.set_dialouge_with_enum(self.chat[clamp(self.point_in_chat, 0, 1024)]);
				}
				
			}
			completed_text = false;
		}
		
		
			
			
	}
	
	#region gui
	self.draw_gui = function(){
		//gonna math for the middle of the screen and the edges of the textbox
		var _text_right_edge = GAME_W / 2 + self.dialouge_box_width / 2 + self.dialouge_margin;
		var _text_left_edge = GAME_W / 2 - self.dialouge_box_width / 2 - self.dialouge_margin;
		
		//the box
		if(self.dialouge_start_time < CURRENT_FRAME) { 
			draw_rectangle(_text_left_edge,self.dialouge_y_top,_text_right_edge,
			self.dialouge_y_height + self.dialouge_y_top - 1,false); 
			
			//the text
			for(var q = 0; q < array_length(self.text_chunks); q++){
				if(q != 0){
					if(self.tc_length[q - 1] != self.text_length[q - 1]){
						break;
					}
				}
				var _len = self.text_length[q];
				self.text_length[q] = clamp(self.text_length[q] + 1,0, self.tc_length[q]);
				
				if(_len == self.text_length[q] && completed_text == false){
					completed_text = true;
					
					//if there are options then get all options for displaying
					if(variable_struct_exists(self.chat[self.point_in_chat], "option_1")){
						//clear options before doing anything
						self.options = [];
						
						// if you have any options theres an option 1
						array_push(self.options, self.chat[self.point_in_chat].option_1);
						array_push(self.option_functions, self.chat[self.point_in_chat].option_1_function);
						
						//get the rest of the options via while loop. i dont use while loops a lot
						var _exists = true;
						var _index = 2;
						while(_exists){
							_exists = variable_struct_exists(self.chat[self.point_in_chat], "option_" + string(_index));
							
							//if theres another option, add it to the options array and check the next one
							if(_exists){
								array_push(self.options, variable_struct_get(self.chat[self.point_in_chat], "option_" + string(_index)));
								array_push(self.option_functions, variable_struct_get(self.chat[self.point_in_chat], "option_" + string(_index) + "_function"));
							}
							
							_index++;
						}
					}
					
					//stop the talking animation for whos talking
					//dont reset the other dude or theyll blink at the same time
					if(string_lower(focus) == "right")
						get(ComponentSpriteRenderer).change_sprite(self.left_mugshot_sprite, left_mugshot)
					else
						get(ComponentSpriteRenderer).change_sprite(self.right_mugshot_sprite,  right_mugshot)
				}
				
				//draw the actual text
				draw_string_condensed(string_copy(self.text_chunks[q],0,self.text_length[q]),
				self.dialouge_margin + _text_left_edge, q * (8 + dialouge_margin) + dialouge_margin + dialouge_y_top);
			}
		} else {
			//make the textbox pop up
			var _crunch = (self.dialouge_start_time - CURRENT_FRAME) / dialouge_startup * (dialouge_y_height / 2);
			draw_rectangle(_text_left_edge + _crunch,self.dialouge_y_top + _crunch,_text_right_edge - _crunch,
			self.dialouge_y_height + self.dialouge_y_top - 1 - _crunch,false); 
		}
		
		//options themselves
		for(var r = 0; r < array_length(self.options); r++){
			//white outline
			draw_set_color(c_white)
			draw_rectangle(_text_right_edge + option_x_offset + 3, self.dialouge_y_height + self.dialouge_y_top + r * 10, option_x_offset + _text_right_edge - string_get_text_length(self.options[r]) - 2, 
				self.dialouge_y_height + self.dialouge_y_top + 3 + r * 10, false)
			draw_rectangle(_text_right_edge + option_x_offset + 2, self.dialouge_y_height + self.dialouge_y_top + r * 10 + 4, option_x_offset + _text_right_edge - string_get_text_length(self.options[r]) - 3, 
				self.dialouge_y_height + self.dialouge_y_top + 6 + r * 10, false)
			draw_rectangle(_text_right_edge + option_x_offset + 1, self.dialouge_y_height + self.dialouge_y_top + r * 10 + 7, option_x_offset + _text_right_edge - string_get_text_length(self.options[r]) - 4, 
				self.dialouge_y_height + self.dialouge_y_top + 10 + r * 10, false)
			
			//draw the black box
			draw_set_color(c_black)
			draw_rectangle(_text_right_edge + option_x_offset, self.dialouge_y_height + self.dialouge_y_top + r * 10 + 1, option_x_offset + _text_right_edge - string_get_text_length(self.options[r]) - 1, 
				self.dialouge_y_height + self.dialouge_y_top + 9 + r * 10, false)
			//left side cutout
			draw_rectangle(_text_right_edge + option_x_offset, self.dialouge_y_height + self.dialouge_y_top + r * 10 + 1, _text_right_edge + option_x_offset + 1, 
				self.dialouge_y_height + self.dialouge_y_top + 2 + r * 10, false)
			draw_rectangle(_text_right_edge + option_x_offset, self.dialouge_y_height + self.dialouge_y_top + r * 10 + 1, _text_right_edge + option_x_offset, 
				self.dialouge_y_height + self.dialouge_y_top + 5 + r * 10, false)
			
			//draw the option text
			draw_string_condensed(self.options[r], _text_right_edge - string_get_text_length(self.options[r]) + 1 + option_x_offset, self.dialouge_y_height + self.dialouge_y_top + 1 + r * 10);
		}
			
		//option selection
		if(array_length(self.options) != 0){
			self.selected_option = ((self.selected_option + array_length(self.options)) + self.input.get_input_pressed_raw("down") - self.input.get_input_pressed_raw("up")) mod (array_length(self.options))
		
			draw_string("<", _text_right_edge + 5 + sin(CURRENT_FRAME / 12) * 2.5 + option_x_offset, self.dialouge_y_height + self.dialouge_y_top + 1 + selected_option * 10)
			draw_string(">", _text_right_edge - 12 + (sin(CURRENT_FRAME / 12 + pi) * 2.5) - string_get_text_length(self.options[self.selected_option]) + 1 + option_x_offset, 
				self.dialouge_y_height + self.dialouge_y_top + 1 + selected_option * 10)
		}
		
		//get(ComponentSpriteRenderer).draw_sprite(_sprite_name_right, 0,  _text_left_edge - 22, dialouge_y_top + 22, string_lower(focus) == "left" ? c_grey : c_white)
		//get(ComponentSpriteRenderer).draw_sprite(_sprite_name_left, 0, _text_right_edge + 22, dialouge_y_top + 22, string_lower(focus) != "left" ? c_grey : c_white, 1, -1)
	}
	#endregion
}

function Dialouge() constructor// idk if this will ever be used. it would help in theory tho
{
    self.sentence = "Dialouge Error!";
	self.mugshots = [X_Mugshot_Angy1, X_Mugshot_Bored1];
	self.focus = "right";
}