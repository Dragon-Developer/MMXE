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
	OptionsContainer = new GuiOptions();
	hudContainer = new GuiPlayerHUD();
	SettingsContainer = new GuiSettingsMenu();
	KeybindsContainer = new GuiKeybinds();
	VolumeContainer = new GuiVolume();
	
	mainMenuContainer.setEnabled(true);
	hudContainer.setEnabled(false);
	SettingsContainer.setEnabled(false);
	OptionsContainer.setEnabled(false);
	KeybindsContainer.setEnabled(false);
	VolumeContainer.setEnabled(false);
	
	
	addChild([mainMenuContainer, hudContainer, SettingsContainer, OptionsContainer, KeybindsContainer, VolumeContainer]);
	
	mouseX = -1;
	mouseY = -1;
	usingMouse = true;
	OMX = -1;
	OMY = -1;
	connected_controller = -1;
	
    step = function() 
	{
		try {
	        var _scroll = mouse_wheel_up() || mouse_wheel_down();
	        var _mx = mouseX;
	        var _my = mouseY;
			
			if(usingMouse){
				var _mx = device_mouse_x_to_gui(0);
		        var _my = device_mouse_y_to_gui(0);	
				
				OMX = device_mouse_x_to_gui(0);
				OMY = device_mouse_y_to_gui(0);
				
				for(var p = 0; p < gamepad_get_device_count(); p++){
					//show_debug_message(string(gamepad_is_connected(p)) + " " + string(p))
					
					if gamepad_is_connected(p) == 1 connected_controller = p
				}
				
				if(gamepad_axis_value(connected_controller, gp_axislh) != 0 || gamepad_axis_value(connected_controller, gp_axislv) != 0){
					usingMouse = false;
				}
			} else {
				
				_mx += gamepad_axis_value(connected_controller, gp_axislh) * 3
				_my += gamepad_axis_value(connected_controller, gp_axislv) * 3
				
				if(OMX != device_mouse_x_to_gui(0) || OMY != device_mouse_y_to_gui(0)){
					usingMouse = true;
				}
			}
			
			if (_mx != mouseX || _my != mouseY || _scroll) {
				onHover({ x: _mx, y: _my })	
			}
			if (mouse_check_button_pressed(mb_left) || gamepad_button_check_pressed(connected_controller, gp_stickl)) {
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