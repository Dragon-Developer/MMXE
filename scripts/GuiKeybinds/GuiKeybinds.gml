// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GuiKeybinds() : GuiContainer() constructor {
	
	setMaximize();
    setWidth(MENU_W);
    setFlexDirection("column");
    setUsingCache(true);
    setBorderSprite(-1);
    
    mainContainer = new GuiContainer(MENU_W, MENU_H)
    mainContainer
        .setAutoWidth(true)
        .setAutoHeight(true)
		.setFlexDirection("column")
        .setJustifyContent("center")
        .setAlignItems("center")
        .setPaddingSize(1)
		.setGap(1)
		
	buttonBack = new GuiButton(64, 14, "<<<Back")
	buttonBack.addEventListener("click", function() {
		global.settings.input = input_player_export(,false, true);
		JSON.save({
			settings: global.settings, 
			player_data: global.player_data
		}, game_save_id + "save.json", true)
		self.setEnabled(false);
		if(room == rm_init)
			parent.SettingsContainer.setEnabled(true);
	});
		
		buttonBack.setAlignItems("left");
		buttonBack.setJustifyContent("end");
		buttonBack.children[0].setFontOffset(3)
	
	//time to automate!
	
	_bindings = [];
	_inputs = [
		"left",
		"right",
		"up",
		"down",
		"jump",
		"dash",
		"shoot",
		"shoot2",
		"shoot3",
		"shoot4",
		"switchLeft",
		"switchRight",
		"pause"
	];
	
	for(input_index = 0; input_index < array_length(_inputs); input_index++){
	
		var _bind_name = input_binding_get(_inputs[input_index]);
		_bind_name = string(_bind_name)
		
		array_push(_bindings, -1);
		
		_bindings[input_index] = new GuiButton(string_get_text_length(_inputs[input_index] + ": " + _bind_name) + 12, 16, _inputs[input_index] + ": " + _bind_name)
		
		_bindings[input_index].verb = _bind_name
		_bindings[input_index].changing_bind = false
		_bindings[input_index].binding = input_binding_get(_inputs[input_index])
		_bindings[input_index].input_name = _inputs[input_index]
		
		_bindings[input_index].setBorderSprite(spr_gui_panel_slim);
		
		with(_bindings[input_index]){
			addEventListener("click", function() {
				if(input_value_is_binding(input_name)) return;
				
				children = [];
				setText("Rebinding")
				setSize(string_get_text_length("Rebinding") + 10,14);
				Rebind(input_name)
				changing_bind = true;
				binding = "Rebinding";
			});
	
			addEventListener("step", function() {
				//check if the current binding is different from the saved binding
				
				if !input_value_is_binding(input_name)
					changing_bind = false;
					
				if changing_bind return;
				
				children = [];
				var _bind_name = input_binding_get(input_name);
				_bind_name = string(_bind_name)
				
				_bind_name = string_replace(_bind_name, "gamepad ", "")
				_bind_name = string_replace(_bind_name, "thumb", "")
				setSize(string_get_text_length(input_name + ": " + _bind_name) + 10,14);
				setText(input_name + ": " + _bind_name)
				children[0].setFontOffset(3)
				
				changing_bind = false;
			});
		}
		
		_bindings[input_index].setAlignItems("left");
		_bindings[input_index].setJustifyContent("end");
	}
	
	var _array = [buttonBack];
	
	for(var p = 0; p < array_length(_inputs); p++){
		array_push(_array, _bindings[p])
	}
	
	mainContainer.addChild(_array);
	addChild([mainContainer]);
}