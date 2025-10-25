function GuiMainMenu() : GuiContainer() constructor {
    setMaximize();
    setWidth(GAME_W);
    setFlexDirection("column");
    setUsingCache(true);
    setBorderSprite(-1);
    
    mainContainer = new GuiContainer();
    mainContainer
        .setAutoWidth(true)
        .setAutoHeight(true)
		.setFlexDirection("column")
        .setJustifyContent("center")
        .setAlignItems("center")
        .setPaddingSize(16)
		.setGap(8)
    
    buttonStart = new GuiButton(160, 32, "Start Game");
	buttonStart.addEventListener("click", function() { 
		self.setEnabled(false);
		global.game = new GameOffline();
		global.player_character[0] = StringToCharacter(global.player_data.last_used_character)
		
		var _possible_armors = global.player_character[0].possible_armors;
		var _selected_armors = global.player_data.last_used_armor;
		
		var _ret = array_create(array_length(_selected_armors))
		
		for(var p = 0; p < array_length(_selected_armors); p++){
			log(_selected_armors[p])
			log(_possible_armors[_selected_armors[p]])
			_ret[p] = _possible_armors[p][_selected_armors[p]]
		}
		
		log(_possible_armors)
		log("rat")
		log(_ret)
			
		global.armors[0] = _ret;
		if(!global.settings.Has_done_intro_stage){
			global.stage_Data.music = "tutorial"
			parent.startGame(rm_intro);
		} else 
			parent.startGame(rm_stage_select);
	});
	
	buttonOnline = new GuiButton(160, 32, "Play Online");
	buttonOnline.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.playOnlineContainer.setEnabled(true);
	});
		
    buttonOptions = new GuiButton(80, 32,"Options");
	buttonOptions.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.SettingsContainer.setEnabled(true);
	});
	
    buttonExit = new GuiButton(60, 27, "Exit"); 
    
    mainContainer.addChild([buttonStart, buttonOnline, buttonOptions, buttonExit]);
    addChild(mainContainer);
}