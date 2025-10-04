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
	
	buttonQuickCreate = new GuiButton(160, 32, "Quick Create Server");
	buttonQuickCreate.addEventListener("click", function() { 
		global.game = new GameOnline();
		global.server = new GameServer(real("3000"));
		global.socket = global.server;
		self.setEnabled(false);
		parent.lobbyMenuContainer.setEnabled(true);
	});
	
	buttonQuickConnect = new GuiButton(160, 32, "Quick Connect");
	buttonQuickConnect.addEventListener("click", function() { 
		var _ip_port = "127.0.0.1:3000";
		var _split = string_split(_ip_port,":");
		global.game = new GameOnline();
		global.client = new GameClient(_split[0], real(_split[1]));
		global.socket = global.client;
		self.setEnabled(false);
		parent.lobbyMenuContainer.setEnabled(false);
		parent.WaitingContainer.setEnabled(true);
	});
		
    buttonOptions = new GuiButton(80, 32,"Options");
	buttonOptions.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.SettingsContainer.setEnabled(true);
	});
	
    buttonExit = new GuiButton(60, 27, "Exit"); 
    
    mainContainer.addChild([buttonStart, buttonOnline, buttonQuickCreate, buttonQuickConnect, buttonOptions, buttonExit]);
    addChild(mainContainer);
}