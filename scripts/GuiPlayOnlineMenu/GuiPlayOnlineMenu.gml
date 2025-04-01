function GuiPlayOnlineMenu() : GuiContainer() constructor {
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
    
    buttonServer = new GuiButton(200, 50, "Create Server");
	buttonServer.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.serverMenuContainer.setEnabled(true);
	});
	
	buttonClient = new GuiButton(200, 50, "Connect Client");
	buttonClient.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.clientMenuContainer.setEnabled(true);
	});
	
	buttonBack = new GuiButton(200, 50, "Back")
	buttonBack.addEventListener("click", function() {
		self.setEnabled(false);
		parent.mainMenuContainer.setEnabled(true);
	});
    
    mainContainer.addChild([buttonServer, buttonClient, buttonBack]);
    addChild(mainContainer);
}