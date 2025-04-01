function GuiPlayerHUD() : GuiContainer() constructor {	
	self
		.setAutoWidth(true)
		.setAutoHeight(true)
		.setAlignItems("start")
		.setAlignSelf("end")
		.setPaddingSize(16)
	
	leftPlayer = new GuiContainer();
	leftPlayer
		.setAutoWidth(true)
		.setHeight(96)
		
	timeContainer = new GuiContainer();
	timeContainer
		.setWidth(96)
		.setHeight(64)
		
	rightPlayer = new GuiContainer();
	rightPlayer
		.setAutoWidth(true)
		.setHeight(96)
		.setJustifyContent("end")
	self.addChild([leftPlayer, timeContainer, rightPlayer]);
}