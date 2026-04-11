function cutscene_do_inputs(_inputs, _actor = self){
	if(_inputs == undefined)
		log("FUCK INPUTS IS UNDEFINED")
	
	return {
		action: _actor.components.get(ComponentCutscene).have_player_move,
		arguments: _inputs,
		criteria: cutscene_player_free
	}
}

function cutscene_player_free(){
	var _plr = instance_nearest(0,0,obj_player)
	
	var _inputs = _plr.components.get(ComponentPlayerInput).using_scripted_inputs;
	
	return !_inputs
}

function cutscene_add_dialouge(_dialouge, _actor = self){
	return {
		action: _actor.components.get(ComponentCutscene).add_dialouge_part,
		arguments: _dialouge,
		criteria: function(){
			return !instance_exists(obj_dialouge);
		}
	}
}

function cutscene_move_player(_position, _offset = false){
	global.TempCutscenePositionVar = _position
	if _offset
		return {
			action: function(){
				var _plr = instance_nearest(0, 0, obj_player)
				_plr.x += global.TempCutscenePositionVar.x;
				_plr.y += global.TempCutscenePositionVar.y;
			},
			criteria: function(){
				return true
			}
		}
	else
		return {
			action: function(){
				var _plr = instance_nearest(0, 0, obj_player)
				_plr.x = global.TempCutscenePositionVar.x;
				_plr.y = global.TempCutscenePositionVar.y;
			},
			criteria: function(){
				return true
			}
		}
}

function cutscene_set_player_state(_state){
	return {
		action: function(_state){
			var _plr = instance_nearest(0, 0, obj_player)
			_plr.components.get(ComponentPlayerMove).fsm.change(_state)
			_plr.components.get(ComponentPlayerMove).locked = false;
		},
		arguments: _state, 
		criteria: function(){
			return true
		}
	}
}