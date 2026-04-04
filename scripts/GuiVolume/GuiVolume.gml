// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GuiVolume()  : GuiContainer() constructor {
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
        .setPaddingSize(4)
		.setGap(4)
	
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
	
	MusicContainer = new GuiContainer();
    MusicContainer
        .setAutoWidth(true)
		.setFlexDirection("row")
        .setJustifyContent("center")
        .setAlignItems("center")
        .setPadding([4,0,4,0])
		.setGap(4)
		.setScrollEnabled(true)
        .setAutoHeight(false)
		.height = 16;
		
	MusicIncreaseVolume = new GuiButton(12,12, ">")
	MusicIncreaseVolume.addEventListener("click", function(_val){
		if(keyboard_check_direct(vk_shift))
		global.settings.Music_Volume += 0.05;
		else
		global.settings.Music_Volume += 0.01;
		global.settings.Music_Volume = clamp(global.settings.Music_Volume, 0, 1);
		MusicVolumeSettings.setText("Music Volume: " + string(floor(global.settings.Music_Volume * 100)))
		audio_sound_gain(global.intro_music, global.settings.Music_Volume * 1.1, 0);
	});
	
	MusicDecreaseVolume = new GuiButton(12,12, "<")
	MusicDecreaseVolume.addEventListener("click", function(_val){
		if(keyboard_check_direct(vk_shift))
		global.settings.Music_Volume -= 0.05;
		else
		global.settings.Music_Volume -= 0.01;
		global.settings.Music_Volume = clamp(global.settings.Music_Volume, 0, 1);
		MusicVolumeSettings.setText("Music Volume: " + string(floor(global.settings.Music_Volume * 100)))
		audio_sound_gain(global.intro_music, global.settings.Music_Volume * 1.1, 0);
	});
	
	MusicVolumeSettings = new GuiText("Music Volume: " + string(floor(global.settings.Music_Volume * 100)))
		
	MusicContainer.addChild([MusicDecreaseVolume, MusicVolumeSettings, MusicIncreaseVolume]);
	
	SoundEffectsContainer = new GuiContainer();
    SoundEffectsContainer
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
		
	SoundEffectsIncreaseVolume = new GuiButton(12,12, ">")
	SoundEffectsIncreaseVolume.addEventListener("click", function(_val){
		if(keyboard_check_direct(vk_shift))
		global.settings.Sound_Effect_Volume += 0.05;
		else
		global.settings.Sound_Effect_Volume += 0.01;
		global.settings.Sound_Effect_Volume = clamp(global.settings.Sound_Effect_Volume, 0, 1);
		SoundEffectsVolumeSettings.setText("Sound Effect Volume: " + string(floor(global.settings.Sound_Effect_Volume * 100)))
		
		with(obj_world){
			components.get(ComponentSoundLoader).volume = global.settings.Sound_Effect_Volume
		}
		
		audio_play_sound(audio_create_stream(working_directory + "sounds/hurt.ogg"),1, false, global.settings.Sound_Effect_Volume * 0.9);
	});
	
	SoundEffectsDecreaseVolume = new GuiButton(12,12, "<")
	SoundEffectsDecreaseVolume.addEventListener("click", function(_val){
		if(keyboard_check_direct(vk_shift))
		global.settings.Sound_Effect_Volume -= 0.05;
		else
		global.settings.Sound_Effect_Volume -= 0.01;
		global.settings.Sound_Effect_Volume = clamp(global.settings.Sound_Effect_Volume, 0, 1);
		SoundEffectsVolumeSettings.setText("Sound Effect Volume: " + string(floor(global.settings.Sound_Effect_Volume * 100)))
		
		with(obj_world){
			components.get(ComponentSoundLoader).volume = global.settings.Sound_Effect_Volume
		}
		
		audio_play_sound(audio_create_stream(working_directory + "sounds/hurt.ogg"),1, false, global.settings.Sound_Effect_Volume * 0.9);
	});
	
	SoundEffectsVolumeSettings = new GuiText("Sound Effect Volume: " + string(floor(global.settings.Sound_Effect_Volume * 100)))
		
	SoundEffectsContainer.addChild([SoundEffectsDecreaseVolume, SoundEffectsVolumeSettings, SoundEffectsIncreaseVolume]);
	
	mainContainer.addChild([buttonBack, MusicContainer, SoundEffectsContainer])
	
	addChild(mainContainer);
}