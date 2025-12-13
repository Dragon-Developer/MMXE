function ZeroSaber() : MeleeWeapon() constructor{
	self.data = [ZeroSaberData];
}

function ZeroSaberData() : MeleeData() constructor{
	
	self.set_player_state = function(_plr, _charge){
		var _current_swing = _plr.states.melee.animation;
		
		if(_current_swing == "atk_3"){
			return;//bail!
		} else if(!_plr.physics.is_on_floor()){
			set_player_melee_info(_plr, "atk_jump", 1, new Vec2(24,-8), new Vec2(64,56), 2)
		} else if(_current_swing == "atk_2"){
			set_player_melee_info(_plr, "atk_3", 5, new Vec2(32,-8), new Vec2(64,64), 2)
		} else if(_current_swing == "atk_1"){
			set_player_melee_info(_plr, "atk_2", 3, new Vec2(32,0), new Vec2(48,32), 1)
		} else {
			set_player_melee_info(_plr, "atk_1", 2, new Vec2(32,-8), new Vec2(40,48), 1)
		}
		
		//_plr.fsm.change("air");
		_plr.fsm.change("melee");
	}
}