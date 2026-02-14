event_inherited();

components.add([
	ComponentWorld,
	ComponentSpriteRenderer,
	ComponentSoundLoader
]);

components.init();

#region Sound Stuff
var _loop_music = global.stage_Data.music + "L";

self.music = self.components.get(ComponentSoundLoader).play_sound(global.stage_Data.music,0,global.stage_Data.music);
if(self.music != undefined)
audio_sound_loop(self.music, true);

self.spawn_particle = function(_particle){
	PARTICLES.components.get(ComponentParticles).add_particle(_particle);
};

self.play_sound = function(_sound, _start_frame = 0, _loop_sound = noone){
	return self.components.get(ComponentSoundLoader).play_sound(_sound,_start_frame, _loop_sound);
}

self.swap_sound = function(_sound, _new_sound){
	return self.components.get(ComponentSoundLoader).swap_sound(_sound, _new_sound);
}

self.play_music = function(_sound){
	self.components.get(ComponentSoundLoader).source_folder = self.components.get(ComponentSoundLoader).music_folder;
	self.components.get(ComponentSoundLoader).volume = global.settings.Music_Volume * 1.1;
	self.components.get(ComponentSoundLoader).stop_sound(self.music);
	self.music = self.components.get(ComponentSoundLoader).play_sound(_sound,0,_sound + "L", global.settings.Music_Volume * 1.1, "music/");
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
#endregion

#region making the projectile Manager

PROJECTILES = instance_create_depth(0,0,-14000,projectile_manager);

PROJECTILES.components.get(ComponentSpriteRenderer).character = "weapon";
PROJECTILES.components.get(ComponentSpriteRenderer).load_sprites();

#endregion

#region making the enemy manager

ENEMIES = instance_create_depth(0,0,-13000,Enemy_manager);

ENEMIES.components.get(ComponentSpriteRenderer).character = "enemy";
ENEMIES.components.get(ComponentSpriteRenderer).load_sprites();

#endregion

#region making the particle manager

PARTICLES = instance_create_depth(0,0,-13500,Particle_manager);

#endregion