function GuiSettings() : GuiContainer() constructor {
    setMaximize();
    setWidth(GAME_W);
    setFlexDirection("column");
    setUsingCache(true);
    setBorderSprite(-1);
	self.verb = -1;
	self.input_index = 0;
    
	#region keybinds and return
    KeybindContainer = new GuiContainer();
    KeybindContainer
        .setAutoWidth(true)
        .setAutoHeight(true)
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("left")
        .setPadding([4,0,4,0])
		.setGap(2)
		.setScrollEnabled(true)
	
	buttonBack = new GuiButton(64, 14, "<<<Back")
	buttonBack.addEventListener("click", function() {
		JSON.save({
			settings: global.settings, 
			player_data: global.player_data
		}, game_save_id + "save.json", true)
		self.setEnabled(false);
		parent.mainMenuContainer.setEnabled(true);
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
				children = [];
				setText("Rebinding")
				setSize(string_get_text_length("Rebinding") + 10,14);
				log(Rebind(input_name))
				changing_bind = true;
				binding = input_binding_get(input_name);
			});
	
			addEventListener("step", function() {
				//check if the current binding is different from the saved binding
				
				if(binding != input_binding_get(input_name))
					changing_bind = false;
					
				if changing_bind return;
				
				children = [];
				var _bind_name = input_binding_get(input_name);
				_bind_name = string(_bind_name)
				setSize(string_get_text_length(input_name + ": " + _bind_name) + 10,14);
				setText(input_name + ": " + _bind_name)
				children[0].setFontOffset(3)
				//setText("bitch")
			});
		}
		
		_bindings[input_index].setAlignItems("left");
		_bindings[input_index].setJustifyContent("end");
	}
	
	var _array = [buttonBack];
	
	for(var p = 0; p < array_length(_inputs); p++){
		array_push(_array, _bindings[p])
	}
	
    KeybindContainer.addChild(_array);
	#endregion
	
	#region other settings
	
	/*
	
	input buffer range
	hold dash to dash on land
	psx style dash jumping
	game scale
	
	*/
	PsxDashJumpToggle = new GuiButton(190, 12, "PSX Style Dash Jumping: " + (global.settings.PSX_Style_Dash_Jumping ? "true" : "false"))
	PsxDashJumpToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("end")
		.children[0].setFontOffset(2)
	PsxDashJumpToggle.addEventListener("click", function(_val){
		global.settings.PSX_Style_Dash_Jumping = !global.settings.PSX_Style_Dash_Jumping;
		PsxDashJumpToggle.children[0].setText("PSX Style Dash Jumping: " + (global.settings.PSX_Style_Dash_Jumping ? "true" : "false"))
	});
	
	DashOnLandingToggle = new GuiButton(190, 12, "Hold Dash While Landing: " + (global.settings.Dash_On_Land ? "true" : "false"))
	DashOnLandingToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("end")
		.children[0].setFontOffset(2)
	DashOnLandingToggle.addEventListener("click", function(_val){
		global.settings.Dash_On_Land = !global.settings.Dash_On_Land;
		DashOnLandingToggle.children[0].setText("Hold Dash While Landing: " + (global.settings.Dash_On_Land ? "true" : "false"))
	});
	
	SettingsContainer = new GuiContainer();
    SettingsContainer
        .setAutoWidth(true)
        .setAutoHeight(true)
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("end")
        .setPadding([4,0,4,0])
		.setGap(4)
		.setScrollEnabled(true)
		
	MusicVolumeBar = new GuiSlidingBar(160, 12);
	MusicVolumeBar.setProgressValue(global.settings.Music_Volume * 160)
	MusicVolumeBar.addEventListener("slide", function(_val){
		global.settings.Music_Volume = _val / MusicVolumeBar.maxProgressValue
		
		MusicVolumeSettings.setText("Music Volume: " + string(floor(_val / MusicVolumeBar.maxProgressValue * 100)) + "%")
	});
	
	MusicVolumeSettings = new GuiText("Music Volume: " + string(floor(MusicVolumeBar.progressValue / MusicVolumeBar.maxProgressValue * 100)) + "%")
	
	SoundEffectVolumeBar = new GuiSlidingBar(160, 12);
	SoundEffectVolumeBar.setProgressValue(global.settings.Sound_Effect_Volume * 160)
	SoundEffectVolumeBar.addEventListener("slide", function(_val){
		global.settings.Sound_Effect_Volume = _val / SoundEffectVolumeBar.maxProgressValue
		
		SoundEffectVolumeSettings.setText("Sound Effect Volume: " + string(floor(_val / SoundEffectVolumeBar.maxProgressValue * 100)) + "%")
	});
	
	SoundEffectVolumeSettings = new GuiText("Sound Effect Volume: " + string(floor(SoundEffectVolumeBar.progressValue / SoundEffectVolumeBar.maxProgressValue * 100)) + "%")
	
	OnlineUsername = new GuiTextInput()
	OnlineUsername.setBorderSprite(spr_gui_panel_slim);
	OnlineUsername.setSprite(undefined);
	OnlineUsername.setSize(180, 20);
	OnlineUsername.setValue(global.settings.online_username);
	
	OnlineUsername.addEventListener("change", function() {
		global.settings.online_username = OnlineUsername.getValue();
		log("updated username")
	});
	
	var _gui_bar_length = 160;
	
	GuiScaleBar = new GuiSlidingBar(_gui_bar_length, 12);
	GuiScaleBar.setProgressValue(global.settings.Game_Scale * ( GuiScaleBar.width / floor(display_get_height() / GAME_H)))
	//GuiScaleBar.setMaxValue()
	//_val / floor(GAME_H / display_get_height())
	GuiScaleBar.addEventListener("slide", function(_val){
		
		_val = floor( lerp(1,floor(display_get_height() / GAME_H) + 2,_val / GuiScaleBar.width))
		global.settings.Game_Scale = _val;
		
		var _text = "Scale: " + string(_val)
		
		if(_val == floor(display_get_height() / GAME_H) + 1)
			_text = "Fullscreen"
		
		GuiScaleText.setText(_text)
	});
	
	GuiScaleBar.Handle.addEventListener("mouseleave", function(_val){
		GuiScaleBar.setProgressValue(floor( lerp(1,floor(display_get_height() / GAME_H) + 2,GuiScaleBar.progressValue / GuiScaleBar.width)) * GuiScaleBar.width / (floor(display_get_height() / GAME_H) + 2))
		global_prepare_application();
	});
	
	GuiScaleText = new GuiText("Scale: " + string(global.settings.Game_Scale))
	
	SettingsContainer.addChild([PsxDashJumpToggle,DashOnLandingToggle, OnlineUsername,MusicVolumeBar, MusicVolumeSettings, SoundEffectVolumeBar, SoundEffectVolumeSettings, GuiScaleBar, GuiScaleText, "e", "q"]);
	#endregion
	
    addChild(KeybindContainer);
    addChild(SettingsContainer);
}