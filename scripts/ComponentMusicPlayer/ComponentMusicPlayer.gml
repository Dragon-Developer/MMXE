function ComponentMusicPlayer() : ComponentSoundLoader() constructor{
	self.source_folder = "/music/";
	self.loops = true;
	self.volume = global.settings.Music_Volume * 1.1;
	self.init = function(){
		self.play_sound(global.stage_Data.music);
	}
	self.stop = function(){
		self.clear_sound();
	}
}