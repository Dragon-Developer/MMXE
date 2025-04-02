function GuiStageSelect() : GuiContainer() constructor {
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
		
	StageButtons = [];
	
	for(var q = 1; q < room_last; q++){
		StageButtons[q - 1] = new GuiButton(200, 32, room_get_name(q));
		StageButtons[q - 1].addEventListener("click", function() { 
			global.game = new GameOffline();
			self.setEnabled(false);
			parent.startGame();
		});
	}
    
    mainContainer.addChild(StageButtons);
    addChild(mainContainer);
}