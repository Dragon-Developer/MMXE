function GuiSettings() : GuiContainer() constructor {
    setMaximize();
    setWidth(GAME_W);
    setFlexDirection("column");
    setUsingCache(true);
    setBorderSprite(-1);
    setPadding([0,0,0,0])
	setGap(0)
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
		global.settings.input = input_player_export(,false, true);
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
	
	if(!variable_struct_exists(global.settings, "dev_commentary")){
		global.settings.dev_commentary = false;
	}
	
	DevCommentToggle = new GuiButton(190, 12, "Developer Commentary: " + (global.settings.dev_commentary ? "true" : "false"))
	DevCommentToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("end")
		.children[0].setFontOffset(2)
	DevCommentToggle.addEventListener("click", function(_val){
		global.settings.dev_commentary = !global.settings.dev_commentary;
		DevCommentToggle.children[0].setText("Developer Commentary: " + (global.settings.dev_commentary ? "true" : "false"))
	});
	
	SettingsContainer = new GuiContainer();
    SettingsContainer
        .setAutoWidth(false)
        .setAutoHeight(true)
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("left")
        .setPadding([32,0,4,0])
		.setGap(2)
		.setScrollEnabled(true)
		.width = 128;
		SettingsContainer.scrollX = -128;
		SettingsContainer.scrolly = 128;
	
	MusicContainer = new GuiContainer();
    MusicContainer
        .setAutoWidth(true)
        .setAutoHeight(true)
		.setFlexDirection("row")
        .setJustifyContent("start")
        .setAlignItems("left")
        .setPadding([4,0,4,0])
		.setGap(4)
		.setScrollEnabled(true)
		
	MusicIncreaseVolume = new GuiButton(12,12, ">")
	MusicIncreaseVolume.addEventListener("click", function(_val){
		if(keyboard_check_direct(vk_shift))
		global.settings.Music_Volume += 0.05;
		else
		global.settings.Music_Volume += 0.01;
		global.settings.Music_Volume = clamp(global.settings.Music_Volume, 0, 1);
		MusicVolumeSettings.setText("Music Volume: " + string(floor(global.settings.Music_Volume * 100)))
		audio_sound_gain(global.intro_music, global.settings.Music_Volume * 1.1, 0);
	});
	
	MusicDecreaseVolume = new GuiButton(12,12, "<")
	MusicDecreaseVolume.addEventListener("click", function(_val){
		if(keyboard_check_direct(vk_shift))
		global.settings.Music_Volume -= 0.05;
		else
		global.settings.Music_Volume -= 0.01;
		global.settings.Music_Volume = clamp(global.settings.Music_Volume, 0, 1);
		MusicVolumeSettings.setText("Music Volume: " + string(floor(global.settings.Music_Volume * 100)))
		audio_sound_gain(global.intro_music, global.settings.Music_Volume * 1.1, 0);
	});
	
	MusicVolumeSettings = new GuiText("Music Volume: " + string(floor(global.settings.Music_Volume * 100)))
		
	MusicContainer.addChild([MusicDecreaseVolume, MusicVolumeSettings, MusicIncreaseVolume]);
	
	SoundEffectsContainer = new GuiContainer();
    SoundEffectsContainer
        .setAutoWidth(true)
        .setAutoHeight(true)
		.setFlexDirection("row")
        .setJustifyContent("start")
        .setAlignItems("left")
        .setPadding([4,0,4,0])
		.setGap(4)
		.setScrollEnabled(true)
		
	SoundEffectsIncreaseVolume = new GuiButton(12,12, ">")
	SoundEffectsIncreaseVolume.addEventListener("click", function(_val){
		if(keyboard_check_direct(vk_shift))
		global.settings.Sound_Effect_Volume += 0.05;
		else
		global.settings.Sound_Effect_Volume += 0.01;
		global.settings.Sound_Effect_Volume = clamp(global.settings.Sound_Effect_Volume, 0, 1);
		SoundEffectsVolumeSettings.setText("Sound Effect Volume: " + string(floor(global.settings.Sound_Effect_Volume * 100)))
		
		audio_play_sound(audio_create_stream(working_directory + "sounds/hurt.ogg"),1, false, global.settings.Sound_Effect_Volume * 0.9);
	});
	
	SoundEffectsDecreaseVolume = new GuiButton(12,12, "<")
	SoundEffectsDecreaseVolume.addEventListener("click", function(_val){
		if(keyboard_check_direct(vk_shift))
		global.settings.Sound_Effect_Volume -= 0.05;
		else
		global.settings.Sound_Effect_Volume -= 0.01;
		global.settings.Sound_Effect_Volume = clamp(global.settings.Sound_Effect_Volume, 0, 1);
		SoundEffectsVolumeSettings.setText("Sound Effect Volume: " + string(floor(global.settings.Sound_Effect_Volume * 100)))
		
		audio_play_sound(audio_create_stream(working_directory + "sounds/hurt.ogg"),1, false, global.settings.Sound_Effect_Volume * 0.9);
	});
	
	SoundEffectsVolumeSettings = new GuiText("Sound Effect Volume: " + string(floor(global.settings.Sound_Effect_Volume * 100)))
		
	SoundEffectsContainer.addChild([SoundEffectsDecreaseVolume, SoundEffectsVolumeSettings, SoundEffectsIncreaseVolume]);

	GuiScaleContainer = new GuiContainer();
    GuiScaleContainer
        .setAutoWidth(true)
        .setAutoHeight(true)
		.setFlexDirection("row")
        .setJustifyContent("start")
        .setAlignItems("left")
        .setPadding([4,0,4,0])
		.setGap(4)
		.setScrollEnabled(true)
		
	GuiScaleIncreaseVolume = new GuiButton(12,12, ">")
	GuiScaleIncreaseVolume.addEventListener("click", function(_val){
		global.settings.Game_Scale += 1;
		
		var _text = "Scale: " + string(global.settings.Game_Scale)
		
		if(global.settings.Game_Scale == floor(display_get_height() / GAME_H) + 1)
			_text = "Fullscreen"
		
		GuiScaleVolumeSettings.setText(_text)
		global_prepare_application();
	});
	
	GuiScaleDecreaseVolume = new GuiButton(12,12, "<")
	GuiScaleDecreaseVolume.addEventListener("click", function(_val){
		global.settings.Game_Scale -= 1;
		
		var _text = "Scale: " + string(global.settings.Game_Scale)
		
		if(global.settings.Game_Scale == floor(display_get_height() / GAME_H) + 1)
			_text = "Fullscreen"
		
		GuiScaleVolumeSettings.setText(_text)
		global_prepare_application();
	});
	
	GuiScaleVolumeSettings = new GuiText("Scale: " + string(global.settings.Game_Scale))
	
	GuiScaleContainer.addChild([GuiScaleDecreaseVolume, GuiScaleVolumeSettings, GuiScaleIncreaseVolume]);
	
	SettingsContainer.addChild([DevCommentToggle,PsxDashJumpToggle,DashOnLandingToggle,MusicContainer, SoundEffectsContainer, GuiScaleContainer]);
	#endregion
	
    addChild(KeybindContainer);
    addChild(SettingsContainer);
}