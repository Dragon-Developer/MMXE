if(global.checkpoint_id != self){
	global.checkpoint_id = self;
	if(visual_effects){
		WORLD.spawn_particle(new CompleteParticle(x, y - 8, 1));
		WORLD.play_sound("checkpoint");
	}
	log("touchdown")
}