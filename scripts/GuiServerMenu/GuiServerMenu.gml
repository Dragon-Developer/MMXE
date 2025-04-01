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
    
    buttonCreate = new GuiButton(200, 50, "Create Server");
	buttonCreate.addEventListener("click", function() { 
		global.game = new GameOnline();
		global.server = new GameServer(real(inputPort.getValue()));
		self.setEnabled(false);
		parent.lobbyMenuContainer.setEnabled(true);
	});
	
	inputPort = new GuiTextInput();
	inputPort.setSize(200, 50);
	inputPort.setValue("3000");
	
	buttonBack = new GuiButton(200, 50, "Back")
	buttonBack.addEventListener("click", function() {
		self.setEnabled(false);
		parent.mainMenuContainer.setEnabled(true);
	});
    
    mainContainer.addChild(["Port", inputPort, buttonCreate, buttonBack]);
    addChild(mainContainer);
}