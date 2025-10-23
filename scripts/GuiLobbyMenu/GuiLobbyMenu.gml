function GuiLobbyMenu() : GuiContainer() constructor {
	self.room_id = 0;
	self.possible_room_ids = [
		rm_headquarters,
		rm_training_stage,
		rm_intro,
		rm_gate_2,
		rm_explose_horneck,
		rm_flame_stag,
		rm_metroid,
		rm_test
	];
	
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
		parent.startMultiplayerLobby(self.possible_room_ids[self.room_id]);
	});
	
	buttonChangeRoom = new GuiButton(200, 20, "Change Room")
	buttonChangeRoom.addEventListener("click", function() {
		self.room_id++;
		self.room_id = self.room_id mod array_length(self.possible_room_ids);
		textRoomName.setText(room_get_name(self.possible_room_ids[self.room_id]))
	});
	
	textRoomName = new GuiText("rm_headquarters")
    
    mainContainer.addChild(["Lobby", buttonStart, buttonChangeRoom,textRoomName]);
    addChild(mainContainer);
}