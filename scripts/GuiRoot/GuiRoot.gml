function GuiRoot() : GuiContainer() constructor {
	setMaximize();
	setWidth(GAME_W);
	setFlexDirection("column");	
	setUsingCache(true);
	setBorderSprite(-1)
	
	startGame = function(_id = 1) {
		hudContainer.setEnabled(true);
		refreshChildren();
		global.game.start();
		if (!is_undefined(global.server)) 
			global.server.rpc.sendNotification("game_start", {
				players: [0, 1]
			}, global.server.getAllSockets());
			log(string(_id) + " is the requested room id")
		room_goto_next();
	}
	
	mainMenuContainer = new GuiMainMenu();
	hudContainer = new GuiPlayerHUD();
	playOnlineContainer = new GuiPlayOnlineMenu();
	serverMenuContainer = new GuiServerMenu();
	lobbyMenuContainer = new GuiLobbyMenu();
	clientMenuContainer = new GuiClientMenu();
	StageSelectContainer = new GuiStageSelect();
	
	mainMenuContainer.setEnabled(true);
	hudContainer.setEnabled(false);
	playOnlineContainer.setEnabled(false);
	serverMenuContainer.setEnabled(false);
	lobbyMenuContainer.setEnabled(false);
	clientMenuContainer.setEnabled(false);
	StageSelectContainer.setEnabled(false);
	
	
	addChild([mainMenuContainer, StageSelectContainer, hudContainer, playOnlineContainer, serverMenuContainer, lobbyMenuContainer, clientMenuContainer]);
	
	mouseX = -1;
	mouseY = -1;
	
    step = function() 
	{
		try {
	        var _scroll = mouse_wheel_up() || mouse_wheel_down();
	        var _mx = device_mouse_x_to_gui(0);
	        var _my = device_mouse_y_to_gui(0);
			if (_mx != mouseX || _my != mouseY || _scroll) {
				onHover({ x: _mx, y: _my })	
			}
			if (mouse_check_button_pressed(mb_left)) {
				onClick({ x: _mx, y: _my });
			}
			mouseX = _mx;
			mouseY = _my;

			var _can_debug = true;
			if (_can_debug && keyboard_check(vk_control) && keyboard_check_pressed(ord("D"))) {
				debug = !debug;
				emitEvent("debug", debug);
				propagate("debug", debug);
			}

			rootStep();
		} catch (err) {
			show_debug_message(err);	
		}
    };
	
	init = function() {
		childrenStep();	
	}
}