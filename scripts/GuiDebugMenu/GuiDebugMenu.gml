function GuiDebugMenu() : GuiContainer() constructor {	
	self
		.setAutoWidth(true)
		.setAutoHeight(true)
		.setAlignItems("start")
		.setAlignSelf("end")
		.setPaddingSize(16)
	
	mainContainer = new GuiContainer();
    mainContainer
        .setAutoWidth(true)
        .setAutoHeight(true)
		.setFlexDirection("column")
        //.setJustifyContent("center")
        //.setAlignItems("center")
        .setPaddingSize(16)
		.setGap(8)
		
	inputPort = new GuiTextInput()
	inputPort.setSize(200, 50);
	inputPort.setValue("3000");
	
	buttonCreate = new GuiButton(200, 50, "Send");
	buttonCreate.addEventListener("click", function() { 
		XEConsole_call(inputPort.getValue());
	});
	
	
	mainContainer.addChild([inputPort, buttonCreate]);
	addChild(mainContainer);
}