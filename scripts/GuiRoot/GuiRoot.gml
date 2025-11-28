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
		//this is for the singleplayer experience. multiplayer isnt a factor here
		
		
		room_transition_to(_id, "standard", 24);
	}
	
	startMultiplayerLobby = function(_room) {
		global.online = true
		hudContainer.setEnabled(true);
		refreshChildren();
		
		if (!is_undefined(global.server)) {
		//excuse my cancer, but i also dont give a fuck
			log("this is the server!")
			var _plrs = [0];
			for(var t = 0; t < array_length(global.server.getAllSockets()); t++){
				array_push(_plrs, t + 1)
				global.server.rpc.sendNotification("set_player_id", {
					_id: t + 1
				}, global.server.getAllSockets()[t]);
				//log(global.server.getAllSockets()[t])
			}
			
			global.game.inputs.setTotalPlayers(array_length(global.server.getAllSockets()) + 1);
			global.game.add_local_players([0]);
			
			global.server.rpc.sendNotification("game_start", {
				players: _plrs,
				room: _room
			}, global.server.getAllSockets());
			
			global.server.players_ready = array_create(array_length(global.server.getAllSockets()) + 1,-1);
			global.server.player_times = array_create(array_length(global.server.getAllSockets()) + 1,-1);
			
			//global.server.playerRpc.send_armors();
			log("server done")
		} else {
			global.client.playerRpc.send_armors();
		}
		global.game.start();
		
		WaitingContainer.setEnabled(false);
		
		room_transition_to(_room, "standard", 24);
	}
	
	startEditor = function(){
		hudContainer.setEnabled(true);
		refreshChildren();
		global.game.start();
		room_goto(rm_editor);
	}
	
	mainMenuContainer = new GuiMainMenu();
	hudContainer = new GuiPlayerHUD();
	playOnlineContainer = new GuiPlayOnlineMenu();
	serverMenuContainer = new GuiServerMenu();
	lobbyMenuContainer = new GuiLobbyMenu();
	clientMenuContainer = new GuiClientMenu();
	SettingsContainer = new GuiSettings();
	WaitingContainer = new GuiWaitingMenu();
	
	mainMenuContainer.setEnabled(true);
	hudContainer.setEnabled(false);
	playOnlineContainer.setEnabled(false);
	serverMenuContainer.setEnabled(false);
	lobbyMenuContainer.setEnabled(false);
	clientMenuContainer.setEnabled(false);
	SettingsContainer.setEnabled(false);
	WaitingContainer.setEnabled(false);
	
	
	addChild([mainMenuContainer, hudContainer, playOnlineContainer, serverMenuContainer, lobbyMenuContainer, clientMenuContainer, SettingsContainer, WaitingContainer]);
	
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