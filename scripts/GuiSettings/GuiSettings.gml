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
		.setGap(4)
		.setScrollEnabled(true)
	
	buttonBack = new GuiButton(64, 16, "Back")
	buttonBack.addEventListener("click", function() {
		self.setEnabled(false);
		parent.mainMenuContainer.setEnabled(true);
	});
		
		buttonBack.setAlignItems("left");
		buttonBack.setJustifyContent("end");
	
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
		
		with(_bindings[input_index]){
			addEventListener("click", function() {
				children = [];
				setText("Rebinding")
				setSize(string_get_text_length("Rebinding") + 12,16);
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
				setSize(string_get_text_length(input_name + ": " + _bind_name) + 12,16);
				setText(input_name + ": " + _bind_name)
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
		
	MusicVolumeBar = new GuiSlidingBar(160, 16);
	MusicVolumeBar.setProgressValue(global.settings.Music_Volume * 160)
	MusicVolumeBar.addEventListener("slide", function(_val){
		global.settings.Music_Volume = _val / MusicVolumeBar.maxProgressValue
		
		MusicVolumeSettings.setText("Music Volume: " + string(floor(_val / MusicVolumeBar.maxProgressValue * 100)) + "%")
	});
	
	MusicVolumeSettings = new GuiText("Music Volume: " + string(floor(MusicVolumeBar.progressValue / MusicVolumeBar.maxProgressValue * 100)) + "%")
	
	SoundEffectVolumeBar = new GuiSlidingBar(160, 16);
	SoundEffectVolumeBar.setProgressValue(global.settings.Sound_Effect_Volume * 160)
	SoundEffectVolumeBar.addEventListener("slide", function(_val){
		global.settings.Sound_Effect_Volume = _val / SoundEffectVolumeBar.maxProgressValue
		
		SoundEffectVolumeSettings.setText("Sound Effect Volume: " + string(floor(_val / SoundEffectVolumeBar.maxProgressValue * 100)) + "%")
	});
	
	SoundEffectVolumeSettings = new GuiText("Sound Effect Volume: " + string(floor(SoundEffectVolumeBar.progressValue / SoundEffectVolumeBar.maxProgressValue * 100)) + "%")
	
	SettingsContainer.addChild([MusicVolumeBar, MusicVolumeSettings, SoundEffectVolumeBar, SoundEffectVolumeSettings]);
	#endregion
	
    addChild(KeybindContainer);
    addChild(SettingsContainer);
}