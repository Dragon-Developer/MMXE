function GuiFrame(_title, _width = 0, _height = 0) : GuiContainer() constructor {
    setSize(_width, _height);
	setColor(c_dkgray);
	setSprite(spr_gui_panel_021);

	setFlexDirection("column");
	setAlignItems("center");
	
    topContainer = new GuiContainer()
	topContainer
		.setFlexDirection("row")
		.setJustifyContent("space-between")
		.setAlignItems("center")
		.setAutoWidth(true) 
		.setHeight(40)
		.setColor(#202020)
		.setSprite(-1)

    bodyContainer = new GuiContainer();
	bodyContainer
		.setFlexDirection("column")
		.setAutoWidth(true)
		.setAutoHeight(true)

	textContainer = new GuiContainer();
	textContainer
		.setFlexDirection("row")
		.setJustifyContent("center")
		.setAlignItems("center")
		.setAutoWidth(true)
		.setAutoHeight(true)
		.setBorderSprite(-1)
		.setPadding([8, 0, 0, 0])
		
	setTitle = function(_title) {
		textTest.setText(_title);
		return self;
	}
    textTest = new GuiText(_title);
	
	textContainer.addChild(textTest);
	
	buttonContainer = new GuiContainer();
	buttonContainer
		.setFlexDirection("row")
		.setJustifyContent("center")
		.setAlignItems("center")
		.setWidth(64)
		.setAutoHeight(true)
	
	topContainer.addChild(textContainer);

    exitButton = new GuiButton(24, 24, new GuiText("X").setColor(c_red)).setSprite(-1);
    exitButton.addEventListener("click", function() {
		emitEvent("close", true);
        setEnabled(false); 
    });
	
	buttonContainer.addChild(exitButton);

    topContainer.addChild(buttonContainer);

    addChild([topContainer, bodyContainer]);
}
