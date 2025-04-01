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
		global.game = new GameOffline();
		self.setEnabled(false);
		parent.startGame();
	});
	
	buttonOnline = new GuiButton(160, 32, "Play Online");
	buttonOnline.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.playOnlineContainer.setEnabled(true);
	});
		
    buttonOptions = new GuiButton(160, 32,"Options");
    buttonExit = new GuiButton(160, 32, "Exit"); 
    
    mainContainer.addChild([buttonStart, buttonOnline, buttonOptions, buttonExit]);
    addChild(mainContainer);
}