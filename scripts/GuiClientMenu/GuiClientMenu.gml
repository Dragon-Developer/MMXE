function GuiClientMenu() : GuiContainer() constructor {
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
    
    buttonConnect = new GuiButton(100, 32, "Connect");
	buttonConnect.addEventListener("click", function() { 
		var _ip_port = inputIpPort.getValue();
		var _split = string_split(_ip_port,":");
		global.game = new GameOnline();
		global.client = new GameClient(_split[0], real(_split[1]));
		global.socket = global.client;
		self.setEnabled(false);
		parent.lobbyMenuContainer.setEnabled(false);
	});
	
	inputIpPort = new GuiTextInput();
	inputIpPort.setSize(200, 32);
	inputIpPort.setValue("localhost:3000");
	
	buttonBack = new GuiButton(100, 32, "Back")
	buttonBack.addEventListener("click", function() {
		self.setEnabled(false);
		parent.mainMenuContainer.setEnabled(true);
	});
    
    mainContainer.addChild(["Port", inputIpPort, buttonConnect, buttonBack]);
    addChild(mainContainer);
}