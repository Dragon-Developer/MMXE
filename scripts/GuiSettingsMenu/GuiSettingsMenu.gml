function GuiSettingsMenu() : GuiContainer() constructor {
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
        .setPaddingSize(4)
		.setGap(4)
		
	buttonBack = new GuiButton(64, 14, "<<<Back")
	buttonBack.addEventListener("click", function() {
		global.settings.input = input_player_export(,false, true);
		JSON.save({
			settings: global.settings, 
			player_data: global.player_data
		}, game_save_id + "save.json", true)
		self.setEnabled(false);
		if(room == rm_init)
			parent.mainMenuContainer.setEnabled(true);
	});
	
	DifficultyOptions = ["Easy", "Normal", "Hard", "XTREME"]
	
	DifficultyToggle = new GuiButton(150, 12, "Difficulty: " + DifficultyOptions[DIFF])
	DifficultyToggle.addEventListener("click", function(_val){
		DIFF = (global.settings.difficulty + 1) mod (array_length(DifficultyOptions))
		DifficultyToggle.children[0].setText("Difficulty: " + DifficultyOptions[DIFF])
	});
	
    buttonKeybinds = new GuiButton(160, 16, "Keybinds");
	buttonKeybinds.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.KeybindsContainer.setEnabled(true);
	});
	
	buttonOptions = new GuiButton(160, 16, "Options");
	buttonOptions.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.OptionsContainer.setEnabled(true);
	});
	
	buttonVolume = new GuiButton(160, 16, "Volume");
	buttonVolume.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.VolumeContainer.setEnabled(true);
	});
	
	mainContainer.addChild([buttonBack, DifficultyToggle, buttonKeybinds, buttonVolume, buttonOptions]);
	addChild([mainContainer]);
}