function BaseStage() constructor{
	stage = rm_explose_horneck;
	stage_select_x = 19;
	stage_select_y = 18;
	
	icon = "undefined";
	music = "tutorial"
	
	requirements = function(){
		return true;
	}
	
	static get_stage_beaten = function(_stage){
		if(!struct_exists(global.player_data, "beaten_stages")) return false;
		if(!struct_exists(global.player_data.beaten_stages, string(stage))) return false;
		
		return struct_get(global.player_data.beaten_stages, string(_stage))
	}
}

/*

how will stages be stored? 

when you beat a stage, it saves it to 










*/