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
		parent.startMultiplayerLobby(rm_race_lobby);
	});
	
	playercount = new GuiButton(200, 14, "Np other players!");
	playercount.setBorderSprite(undefined);
	playercount.setSprite(undefined);
	playercount.addEventListener("step", function() { 
		if(IS_ONLINE)
			playercount.setText("Playercount: " + string( array_length(global.game.__local_players)));
	});
    
    mainContainer.addChild([playercount, buttonStart]);
    addChild(mainContainer);
}