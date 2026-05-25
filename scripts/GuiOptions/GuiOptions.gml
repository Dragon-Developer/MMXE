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
	
	//when i dont want people to delete their old save data i add new data here
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
	if(!variable_struct_exists(global.player_data, "seen_fortress_cutscene")){
		global.player_data.seen_fortress_cutscene = false;
	}
	if(!variable_struct_exists(global.player_data, "quick_up_dash")){
		global.player_data.quick_up_dash = false;
	}
	if(!variable_struct_exists(global.settings, "extra_particles")){
		global.settings.extra_particles = true;
	}
	if(!variable_struct_exists(global.settings, "x8_armors_show_special_weapons")){
		global.settings.x8_armors_show_special_weapons = false;
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
		global.settings.shop_enabled = [];
	}
	if(!variable_struct_exists(global.settings, "shop_enabled")){
		global.settings.shop_items = [];
		global.settings.shop_enabled = [];
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
	
	QuickUpDashToggle = new GuiButton(190, 12, "Quick Up Dash: " + (global.player_data.quick_up_dash ? "true" : "false"))
	QuickUpDashToggle
		.setFlexDirection("column")
        .setJustifyContent("left")
        .setAlignItems("center")
		.children[0].setFontOffset(2)
	QuickUpDashToggle.addEventListener("click", function(_val){
		global.player_data.quick_up_dash = !global.player_data.quick_up_dash;
		QuickUpDashToggle.children[0].setText("Quick Up Dash: " + (global.player_data.quick_up_dash ? "true" : "false"))
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
	
	mainContainer.addChild([buttonBack, DevCommentToggle, ScoreShowcaseToggle, PsxDashJumpToggle, QuickUpDashToggle, DoubleTapDashToggle, DashOnLandingToggle]);
	
	addChild(mainContainer);
}