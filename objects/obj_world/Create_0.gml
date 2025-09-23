event_inherited();

components.add([
	ComponentWorld,
	ComponentParticles,
	//ComponentMusicPlayer,//one to handle music
	ComponentSoundLoader//one to handle sound effects
]);

components.init();

self.music = self.components.get(ComponentSoundLoader).play_sound(global.stage_Data.music);

spawn_particle = function(_particle){
	self.components.get(ComponentParticles).add_particle(_particle);
};

self.play_sound = function(_sound, _start_frame = 0, _loops = false){
	return self.components.get(ComponentSoundLoader).play_sound(_sound,_start_frame, _loops);
}

self.swap_sound = function(_sound, _new_sound){
	return self.components.get(ComponentSoundLoader).swap_sound(_sound, _new_sound);
}

self.play_music = function(_sound){
	self.components.get(ComponentSoundLoader).source_folder = self.components.get(ComponentSoundLoader).music_folder;
	self.components.get(ComponentSoundLoader).volume = global.settings.Music_Volume * 1.1;
	self.components.get(ComponentSoundLoader).stop_sound(self.music);
	self.music = self.components.get(ComponentSoundLoader).play_sound(_sound,,true);
	self.components.get(ComponentSoundLoader).source_folder = self.components.get(ComponentSoundLoader).sounds_folder;
	self.components.get(ComponentSoundLoader).volume = global.settings.Sound_Effect_Volume * 0.9;
	return self.music;
}

self.stop_sound = function(_sound){
	self.components.get(ComponentSoundLoader).stop_sound(_sound);
}

self.clear_sound = function(){
	self.components.get(ComponentSoundLoader).stop_sound();
	//self.components.get(ComponentMusicPlayer).stop_sound();
	audio_stop_all();
}

self.stop_music = function(){self.stop_sound(self.music)};

self.play_music(global.stage_Data.music)
log(string(global.settings.Music_Volume) + " is the volume")