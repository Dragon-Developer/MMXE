function ComponentDialouge() : ComponentBase() constructor{
	var _dia = {   sentence : "NOP this no work",
		mugshot_left : X_Mugshot_Angy1,
		mugshot_right : X_Mugshot1,
		focus : "right"
	}
	self.chat = [_dia];
	self.point_in_chat = 0;
	self.current_text = "dummy";
	self.right_mugshot = X_Mugshot_Bored1;
	self.left_mugshot = X_Mugshot_Angy1;//there needs to be a function that auto creates these sprites
	self.focus = "right";
	self.dialouge_startup = 30;//half a second of the box popping up
	self.text_chunks = ["Component Error!"];//i need to split text up so the words dont trail off
	self.tc_length = [32];//cache these values instead of regenerating them every frame. the text doesnt change mid sentence.
	self.text_length = [32];
	self.input = noone;
	
	self.animation_index = 0;//a timer for a thing. 
	
	self.dialouge_box_width = 192;//not including mugshots. those are tacked onto the side.
	self.dialouge_margin = 2;//the distance between the edge of the textbox and the text
	self.dialouge_y_top = 16;
	self.dialouge_y_height = 44;
	
	self.init = function(){
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
		log(_dialouge)
		self.set_dialouge(_dialouge.sentence, _dialouge.mugshot_left, _dialouge.mugshot_right, _dialouge.focus);
	}
	
	self.set_dialouge = function(_text, _mugshot_left = X_Mugshot1, _mugshot_right = X_Mugshot1, _focus = "right"){
		
		self.text_chunks = [];
		self.tc_length = [];
		self.text_length = [];
		
		log(_text);
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
		self.left_mugshot = _mugshot_left;
		self.right_mugshot = _mugshot_right;
		self.focus = _focus;
		//return _text;
	};
	
	self.step = function(){
		if(self.input.get_input_pressed_raw("jump")){
			if(self.text_length[array_length(self.text_length) - 1] != self.tc_length[array_length(self.text_length) - 1]){
				self.text_length = self.tc_length;
			}else{
				self.point_in_chat++;
				if(self.point_in_chat >= array_length(self.chat)){
					ENTITIES.destroy_instance(self.get_instance());
				} else	{
					self.set_dialouge_with_enum(self.chat[self.point_in_chat]);
				}
			}
		}
	}
	
	#region gui
	self.draw_gui = function(){
		//gonna math for the middle of the screen and the edges of the textbox
		var _text_right_edge = GAME_W / 2 + self.dialouge_box_width / 2 + self.dialouge_margin;
		var _text_left_edge = GAME_W / 2 - self.dialouge_box_width / 2 - self.dialouge_margin;
		
		draw_rectangle(_text_left_edge,self.dialouge_y_top,_text_right_edge,
		self.dialouge_y_height + self.dialouge_y_top - 1,false);
		
		for(var q = 0; q < array_length(self.text_chunks); q++){
			if(q != 0){
				if(self.tc_length[q - 1] != self.text_length[q - 1]){
					break;
				}
			}
			self.text_length[q] = clamp(self.text_length[q] + 1,0, self.tc_length[q]);
			draw_string_condensed(string_copy(self.text_chunks[q],0,self.text_length[q]),
			self.dialouge_margin + _text_left_edge, q * (8 + dialouge_margin) + dialouge_margin + dialouge_y_top);
		}
		
		var _left_col = (string_lower(self.focus) == "right" ? c_grey : c_white);// i used string_lower to allow people to use right and Right.
		var _right_col = (string_lower(self.focus) == "left" ? c_grey : c_white);// its going to happen, someone is going to say they put in right when
		//they put in Right or RIght. heck, they could do RIGHT.
		
		if(string_lower(self.focus) == "right" && array_last(self.text_length) != array_last(self.tc_length)){
			if(self.animation_index % 20 > 10)
				draw_sprite_ext(right_mugshot, 3, _text_right_edge + 1 + sprite_get_width(right_mugshot), self.dialouge_y_top,-1,1,0,_right_col,1);
			else 
				draw_sprite_ext(right_mugshot, 0, _text_right_edge + 1 + sprite_get_width(right_mugshot), self.dialouge_y_top,-1,1,0,_right_col,1);
		} else if(self.animation_index % 120 > 105){
			if(self.animation_index % 120 > 115)
				draw_sprite_ext(right_mugshot, 1, _text_right_edge + 1 + sprite_get_width(right_mugshot), self.dialouge_y_top,-1,1,0,_right_col,1);
			else if(self.animation_index % 120 > 110)
				draw_sprite_ext(right_mugshot, 2, _text_right_edge + 1 + sprite_get_width(right_mugshot), self.dialouge_y_top,-1,1,0,_right_col,1);
			else
				draw_sprite_ext(right_mugshot, 1, _text_right_edge + 1 + sprite_get_width(right_mugshot), self.dialouge_y_top,-1,1,0,_right_col,1);
			
		} else {
			draw_sprite_ext(right_mugshot, 0, _text_right_edge + 1 + sprite_get_width(right_mugshot), self.dialouge_y_top,-1,1,0,_right_col,1);
		}
		if(string_lower(self.focus) == "left" && array_last(self.text_length) != array_last(self.tc_length)){
			if(self.animation_index % 20 > 10)
				draw_sprite_ext(left_mugshot, 3, _text_left_edge - sprite_get_width(left_mugshot), self.dialouge_y_top, 1, 1, 0, _left_col, 1);
			else 
				draw_sprite_ext(left_mugshot, 0, _text_left_edge - sprite_get_width(left_mugshot), self.dialouge_y_top, 1, 1, 0, _left_col, 1);
		} else if(self.animation_index % 120 > 105){
			if(self.animation_index % 120 > 115)
				draw_sprite_ext(left_mugshot, 1, _text_left_edge - sprite_get_width(left_mugshot), self.dialouge_y_top, 1, 1, 0, _left_col, 1);
			else if(self.animation_index % 120 > 110)
				draw_sprite_ext(left_mugshot, 2, _text_left_edge - sprite_get_width(left_mugshot), self.dialouge_y_top, 1, 1, 0, _left_col, 1);
			else
				draw_sprite_ext(left_mugshot, 1, _text_left_edge - sprite_get_width(left_mugshot), self.dialouge_y_top, 1, 1, 0, _left_col, 1);
			
		} else {
			draw_sprite_ext(left_mugshot, 0, _text_left_edge - sprite_get_width(left_mugshot), self.dialouge_y_top, 1, 1, 0, _left_col, 1);
		}
		self.animation_index = (self.animation_index + 1) % 120;
	}
	#endregion
	
	self.generate_mugshots = function(){
		//collage shit. animation uses it so go reference that for generating the sprite. 
		
		return X_Mugshot1;//this is temporary. it will also not get used for the moment.
	}
}

function Dialouge() constructor
{
    self.sentence = "Dialouge Error!";
	self.mugshots = [X_Mugshot_Angy1, X_Mugshot_Bored1];
	self.focus = "right";
}