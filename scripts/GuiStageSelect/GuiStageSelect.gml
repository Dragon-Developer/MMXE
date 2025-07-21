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
        .setPaddingSize(4)
		.setGap(4)
		
	StageButtons = [];
	Stages = [rm_desert_bus, rm_test,rm_horizontal_test, rm_gate_2]
	
	//TIME TO DO THIS SHIT MANUALLY!
	
	StageButtons[0] = new GuiButton(200, 32, "Test Room Desert Bus");
	StageButtons[0].addEventListener("click", function() { 
		global.game = new GameOffline();
		self.setEnabled(false);
		parent.startGame(1);
	});
	
	StageButtons[1] = new GuiButton(200, 32, "Test Room Single");
	StageButtons[1].addEventListener("click", function() { 
		global.game = new GameOffline();
		self.setEnabled(false);
		parent.startGame(2);
	});
	
	StageButtons[2] = new GuiButton(200, 32, "headquarters");
	StageButtons[2].addEventListener("click", function() { 
		global.game = new GameOffline();
		self.setEnabled(false);
		parent.startGame(rm_headquarters);
	});
	
	StageButtons[3] = new GuiButton(200, 32, "Gate 2");
	StageButtons[3].addEventListener("click", function() { 
		global.game = new GameOffline();
		self.setEnabled(false);
		parent.startGame(4);
	});
	
	StageButtons[4] = new GuiButton(200, 32, "Explose Horneck");
	StageButtons[4].addEventListener("click", function() { 
		global.game = new GameOffline();
		self.setEnabled(false);
		parent.startGame(5);
	});
	
	StageButtons[5] = new GuiButton(200, 32, "infinite test");
	StageButtons[5].addEventListener("click", function() { 
		global.game = new GameOffline();
		self.setEnabled(false);
		parent.startGame(6);
	});
    
    mainContainer.addChild(StageButtons);
    addChild(mainContainer);
}