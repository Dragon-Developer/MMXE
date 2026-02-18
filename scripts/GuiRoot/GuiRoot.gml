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
	
	startEditor = function(){
		hudContainer.setEnabled(true);
		refreshChildren();
		global.game.start();
		room_goto(rm_editor);
	}
	
	mainMenuContainer = new GuiMainMenu();
	hudContainer = new GuiPlayerHUD();
	SettingsContainer = new GuiSettings();
	
	mainMenuContainer.setEnabled(true);
	hudContainer.setEnabled(false);
	SettingsContainer.setEnabled(false);
	
	
	addChild([mainMenuContainer, hudContainer, SettingsContainer]);
	
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