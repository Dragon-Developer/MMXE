function GuiSettings() : GuiContainer() constructor {
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
        .setPaddingSize(4)
		.setGap(4)
		
	
	//guess everyone is boned until dark makes sliders or left/right selectors
    
	buttonBack = new GuiButton(50, 13, "Back")
	buttonBack.addEventListener("click", function() {
		self.setEnabled(false);
		parent.mainMenuContainer.setEnabled(true);
	});
	
    mainContainer.addChild([buttonBack]);
    addChild(mainContainer);
}