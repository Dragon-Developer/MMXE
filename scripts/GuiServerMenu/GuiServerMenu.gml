function GuiServerMenu() : GuiContainer() constructor {
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
    
    buttonCreate = new GuiButton(200, 40, "Create Server (Player Ghosts)");
	buttonCreate.addEventListener("click", function() { 
		global.game = new GameOnlineFuckItWeBall();
		global.server = new GameServer(real(inputPort.getValue()));
		global.socket = global.server;
		self.setEnabled(false);
		parent.lobbyMenuContainer.setEnabled(true);
	});
	
	buttonCreateLockstep = new GuiButton(200, 30, "Create Server (Lockstep)");
	buttonCreateLockstep.addEventListener("click", function() { 
		global.game = new GameOnline();
		global.server = new GameServer(real(inputPort.getValue()));
		global.socket = global.server;
		self.setEnabled(false);
		parent.lobbyMenuContainer.setEnabled(true);
	});
	
	buttonCreateRollback = new GuiButton(200, 20, "Create Server (Rollback)");
	buttonCreateRollback.addEventListener("click", function() { 
		global.game = new GameOnlineRollback();
		global.server = new GameServer(real(inputPort.getValue()));
		global.socket = global.server;
		self.setEnabled(false);
		parent.lobbyMenuContainer.setEnabled(true);
	});
	
	inputPort = new GuiTextInput()
	inputPort.setSize(200, 40);
	inputPort.setValue("3000");
	
	buttonBack = new GuiButton(80, 20, "Back")
	buttonBack.addEventListener("click", function() {
		self.setEnabled(false);
		parent.mainMenuContainer.setEnabled(true);
	});
    
    mainContainer.addChild(["Port", inputPort, buttonCreate,buttonCreateLockstep,buttonCreateRollback, buttonBack]);
    addChild(mainContainer);
}