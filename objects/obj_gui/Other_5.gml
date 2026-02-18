try{
	if(instance_exists(GAME)){
		GAME.game_loop.do_action_with_all_components(function(_comp){ENTITIES.remove_component(_comp)})
	}
} catch(_err){
	//do nothing lol
}

audio_stop_all()