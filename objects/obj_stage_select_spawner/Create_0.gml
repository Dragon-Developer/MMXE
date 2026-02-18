event_inherited();
entity_object = obj_stage_select;
on_spawn = function(_player) {
	_player.components.get(ComponentPlayerInput).set_player_index(0);
}

global.stage_Data = {
		room: rm_explose_horneck, 
		x: 19, 
		y: 18, 
		beat: false, 
		icon: "gate", 
		music: "StageSelect"
	}

WORLD = ENTITIES.create_instance(obj_world);