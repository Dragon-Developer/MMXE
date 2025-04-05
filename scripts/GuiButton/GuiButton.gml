function GuiButton(_width = 0, _height = 0, _child = []) : GuiContainer() constructor {
	__mouseCursor.hover = cr_handpoint;
	borderColors.hover = #40b0f0;
	setText = function(_child) {
		addChild(_child);
	}
	setBorderSprite(spr_button_bounding);
	setSize(_width, _height);
	setFlexDirection("row");
	setJustifyContent("space-evenly");
	setAlignItems("center");
	setColor(#202020);
	setBorderColor(borderColors.normal);
	setBorderIndex(4);
    setText(_child);
}
