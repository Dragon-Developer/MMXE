function GuiLobbyMenu() : GuiContainer() constructor {
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
    
    buttonStart = new GuiButton(200, 50, "Start");
	buttonStart.addEventListener("click", function() { 
		self.setEnabled(false);
		parent.startGame(rm_explose_horneck);
	});
	
	buttonBack = new GuiButton(200, 50, "Back")
	buttonBack.addEventListener("click", function() {
		self.setEnabled(false);
		parent.mainMenuContainer.setEnabled(true);
	});
    
    mainContainer.addChild(["Lobby", buttonStart]);
    addChild(mainContainer);
}