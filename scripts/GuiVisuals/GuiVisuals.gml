// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GuiVisuals() : GuiContainer() constructor {

	setMaximize();
    setWidth(MENU_W);
    setFlexDirection("column");
    setUsingCache(true);
    setBorderSprite(-1);
    
    mainContainer = new GuiContainer(MENU_W, MENU_H)
    mainContainer
        .setAutoWidth(true)
        .setAutoHeight(true)
		.setFlexDirection("column")
        .setJustifyContent("center")
        .setAlignItems("center")
        .setPaddingSize(1)
		.setGap(1)
	
	buttonBack = new GuiButton(64, 14, "<<<Back")
	buttonBack.addEventListener("click", function() {
		global.settings.input = input_player_export(,false, true);
		JSON.save({
			settings: global.settings, 
			player_data: global.player_data
		}, game_save_id + "save.json", true)
		self.setEnabled(false);
		if(room == rm_init)
			parent.SettingsContainer.setEnabled(true);
	});
	
	//buttons that do things
	
	GuiScaleContainer = new GuiContainer();
    GuiScaleContainer
        .setAutoWidth(true)
        .setAutoHeight(true)
		.setFlexDirection("row")
        .setJustifyContent("center")
        .setAlignItems("center")
        .setPadding([4,0,4,0])
		.setGap(4)
		.setScrollEnabled(true)
        .setAutoHeight(false)
		.height = 16;
		
	GuiScaleIncreaseVolume = new GuiButton(12,12, ">")
	GuiScaleIncreaseVolume.addEventListener("click", function(_val){
		global.settings.Game_Scale += 1;
		
		var _text = "Scale: " + string(global.settings.Game_Scale)
		
		if(global.settings.Game_Scale == floor(display_get_height() / GAME_H) + 1)
			_text = "Fullscreen"
		
		GuiScaleVolumeSettings.setText(_text)
		global_prepare_application();
	});
	
	GuiScaleDecreaseVolume = new GuiButton(12,12, "<")
	GuiScaleDecreaseVolume.addEventListener("click", function(_val){
		global.settings.Game_Scale -= 1;
		
		var _text = "Scale: " + string(global.settings.Game_Scale)
		
		if(global.settings.Game_Scale == floor(display_get_height() / GAME_H) + 1)
			_text = "Fullscreen"
		
		GuiScaleVolumeSettings.setText(_text)
		global_prepare_application();
	});
	
	GuiScaleVolumeSettings = new GuiText("Scale: " + string(global.settings.Game_Scale))
	
	GuiScaleContainer.addChild([GuiScaleDecreaseVolume, GuiScaleVolumeSettings, GuiScaleIncreaseVolume]);
	
	
	
	ChargeFlashToggle = new GuiButton(190, 12, "Charge Flash: " + (global.settings.charge_flash ? "true" : "false"))
	ChargeFlashToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	ChargeFlashToggle.addEventListener("click", function(_val){
		global.settings.charge_flash = !global.settings.charge_flash;
		ChargeFlashToggle.children[0].setText("Charge Flash: " + (global.settings.charge_flash ? "true" : "false"))
	});
	
	var _text = "4:3"
		
		if(global.settings.screen_scale_x == 320){
			_text = "16:9"
		} else if(global.settings.screen_scale_x == 426){
			_text = "SNES"
		} else {
			_text = "4:3"
		}
	
	ScreenScaleToggle = new GuiButton(190, 12, "Screen Scale: " + _text)
	ScreenScaleToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	ScreenScaleToggle.addEventListener("click", function(_val){
		var _text = "4:3"
		
		if(global.settings.screen_scale_x == 320){
			global.settings.screen_scale_x = 426;
			global.settings.screen_scale_y = 240;
			_text = "16:9"
		} else if(global.settings.screen_scale_x == 426){
			global.settings.screen_scale_x = 256;
			global.settings.screen_scale_y = 240;
			_text = "SNES"
		} else {
			global.settings.screen_scale_x = 320;
			global.settings.screen_scale_y = 240;
			_text = "4:3"
		}
		global.game_w = global.settings.screen_scale_x;
		global.game_h = global.settings.screen_scale_y;
		
		global_prepare_application();
		
		ScreenScaleToggle.children[0].setText("Screen Scale: " + _text)
	});
	
	HitNumberToggle = new GuiButton(190, 12, "Hit Numbers: " + (global.settings.hit_numbers ? "true" : "false"))
	HitNumberToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	HitNumberToggle.addEventListener("click", function(_val){
		global.settings.hit_numbers = !global.settings.hit_numbers;
		HitNumberToggle.children[0].setText("Hit Numbers: " + (global.settings.hit_numbers ? "true" : "false"))
	});
	
	ExtraParticlesToggle = new GuiButton(190, 12, "Extra Particle Effects: " + (global.settings.extra_particles ? "true" : "false"))
	ExtraParticlesToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	ExtraParticlesToggle.addEventListener("click", function(_val){
		global.settings.extra_particles = !global.settings.extra_particles;
		ExtraParticlesToggle.children[0].setText("Extra Particle Effects: " + (global.settings.extra_particles ? "true" : "false"))
	});
	
	X8ColorsToggle = new GuiButton(190, 12, "X8 armors show weapon colors: " + (global.settings.x8_armors_show_special_weapons ? "yes" : "no"))
	X8ColorsToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	X8ColorsToggle.addEventListener("click", function(_val){
		global.settings.x8_armors_show_special_weapons = !global.settings.x8_armors_show_special_weapons;
		X8ColorsToggle.children[0].setText("X8 armors show weapon colors: " + (global.settings.x8_armors_show_special_weapons ? "yes" : "no"))
	});
	
	//final stuffs
	
	mainContainer.addChild([buttonBack, ScreenScaleToggle, ExtraParticlesToggle, HitNumberToggle, ChargeFlashToggle, X8ColorsToggle, GuiScaleContainer]);
	
	addChild(mainContainer);
}