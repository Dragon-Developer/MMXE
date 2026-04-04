function GuiMainMenu() : GuiContainer() constructor {
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
    
	titleImage = new GuiSprite(spr_start_menu2)
	
    buttonStart = new GuiButton(160, 16, "Start Game");
	buttonStart.setBorderSprite(undefined);
	buttonStart.setSprite(undefined);
	buttonStart.addEventListener("click", function() { 
		self.setEnabled(false);
		global.game = new GameOffline();
		global.player_character[0] = StringToCharacter(global.player_data.last_used_character)

		var _selected_armors = global.player_data.last_used_armor[global.character_index];
			
		global.armors[0] = _selected_armors;
		if(!global.settings.Has_done_intro_stage){
			global.stage_Data.music = "tutorial"
			parent.startGame(rm_intro);
		} else 
			parent.startGame(rm_stage_select);
	});
	
	buttonSettings = new GuiButton(80, 16,"Settings");
	buttonSettings.setBorderSprite(undefined);
	buttonSettings.setSprite(undefined);
	buttonSettings.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.SettingsContainer.setEnabled(true);
	});
	
    buttonExit = new GuiButton(60, 16, "Exit"); 
	buttonExit.setBorderSprite(undefined);
	buttonExit.setSprite(undefined);
    
    mainContainer.addChild([titleImage, buttonStart, buttonSettings, buttonExit]);
    addChild(mainContainer);
}