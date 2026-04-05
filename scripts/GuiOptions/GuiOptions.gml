// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GuiOptions() : GuiContainer() constructor {
	
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
	
	if(!variable_struct_exists(global.settings, "charge_flash")){
		global.settings.charge_flash = true;
	}
	if(!variable_struct_exists(global.settings, "race_song")){
		global.settings.race_song = "Saphira_The_Unleashed_Power";
	}
	if(!variable_struct_exists(global.player_data, "metals")){
		global.player_data.metals = 0;
	}
	if(!variable_struct_exists(global.player_data, "weapon_energy")){
		global.player_data.weapon_energy = 28;
	}
	if(!variable_struct_exists(global.settings, "extra_particles")){
		global.settings.extra_particles = true;
	}
	if(!variable_struct_exists(global.settings, "hit_numbers")){
		global.settings.hit_numbers = true;
	}
	if(!variable_struct_exists(global.settings, "double_tap_dash")){
		global.settings.double_tap_dash = false;
	}
	if(!variable_struct_exists(global.settings, "score_showcase")){
		global.settings.score_showcase = false;
	}
	if(!variable_struct_exists(global.settings, "difficulty")){
		DIFF = 1;
	}
	if(!variable_struct_exists(global.settings, "shop_items")){
		global.settings.shop_items = [];
	}
	if(!variable_struct_exists(global.settings, "screen_scale_x")){
		global.settings.screen_scale_x = 320;
		global.settings.screen_scale_y = 240;
	} else {
		global.game_w = global.settings.screen_scale_x;
		global.game_h = global.settings.screen_scale_y;
	}
	
	PsxDashJumpToggle = new GuiButton(190, 12, "PSX Style Dash Jumping: " + (global.settings.PSX_Style_Dash_Jumping ? "true" : "false"))
	PsxDashJumpToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	PsxDashJumpToggle.addEventListener("click", function(_val){
		global.settings.PSX_Style_Dash_Jumping = !global.settings.PSX_Style_Dash_Jumping;
		PsxDashJumpToggle.children[0].setText("PSX Style Dash Jumping: " + (global.settings.PSX_Style_Dash_Jumping ? "true" : "false"))
	});
	
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
	
	DoubleTapDashToggle = new GuiButton(190, 12, "Double Tap Dash: " + (global.settings.double_tap_dash ? "true" : "false"))
	DoubleTapDashToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	DoubleTapDashToggle.addEventListener("click", function(_val){
		global.settings.double_tap_dash = !global.settings.double_tap_dash;
		DoubleTapDashToggle.children[0].setText("Double Tap Dash: " + (global.settings.double_tap_dash ? "true" : "false"))
	});
	
	ScoreShowcaseToggle = new GuiButton(190, 12, "Score Showcase: " + (global.settings.score_showcase ? "true" : "false"))
	ScoreShowcaseToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	ScoreShowcaseToggle.addEventListener("click", function(_val){
		global.settings.score_showcase = !global.settings.score_showcase;
		ScoreShowcaseToggle.children[0].setText("Score Showcase: " + (global.settings.score_showcase ? "true" : "false"))
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
	
	DashOnLandingToggle = new GuiButton(190, 12, "Hold Dash While Landing: " + (global.settings.Dash_On_Land ? "true" : "false"))
	DashOnLandingToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	DashOnLandingToggle.addEventListener("click", function(_val){
		global.settings.Dash_On_Land = !global.settings.Dash_On_Land;
		DashOnLandingToggle.children[0].setText("Hold Dash While Landing: " + (global.settings.Dash_On_Land ? "true" : "false"))
	});
	
	if(!variable_struct_exists(global.settings, "dev_commentary")){
		global.settings.dev_commentary = false;
	}
	
	DevCommentToggle = new GuiButton(190, 12, "Developer Commentary: " + (global.settings.dev_commentary ? "true" : "false"))
	DevCommentToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	DevCommentToggle.addEventListener("click", function(_val){
		global.settings.dev_commentary = !global.settings.dev_commentary;
		DevCommentToggle.children[0].setText("Developer Commentary: " + (global.settings.dev_commentary ? "true" : "false"))
	});

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
	
	mainContainer.addChild([buttonBack, DevCommentToggle, ScreenScaleToggle, ScoreShowcaseToggle, ChargeFlashToggle, ExtraParticlesToggle, HitNumberToggle, PsxDashJumpToggle, DoubleTapDashToggle, DashOnLandingToggle, GuiScaleContainer]);
	
	addChild(mainContainer);
}