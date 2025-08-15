event_inherited();

components.add([
	ComponentWorld,
	ComponentParticles,
	ComponentMusicPlayer,//one to handle music
	ComponentSoundLoader//one to handle sound effects
]);

components.init();

spawn_particle = function(_particle){
	self.components.get(ComponentParticles).add_particle(_particle);
};

self.play_sound = function(_sound){
	return self.components.get(ComponentSoundLoader).play_sound(_sound);
}

self.stop_sound = function(_sound){
	self.components.get(ComponentSoundLoader).stop_sound(_sound);
}