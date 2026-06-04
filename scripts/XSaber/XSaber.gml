function XSaber() : MeleeWeapon() constructor{
	self.data = [XSaberData];
	self.not_selectable = true;
}

function XSaberData() : MeleeData() constructor{
	//theres a thousand and one ways to handle this
	//i dont think i did it in the best way possible
	//notably moves that also change the player's position would also have to be state based
	//but you dont switch weapons to get to them so do i add them as special weapons and add the checks here?
	self.create = function(_inst){
		WORLD.play_sound("saber_swing");
	}

	self.set_player_state = function(_plr, _charge){
		var _current_swing = _plr.states.melee.animation;
		if(_current_swing == "atk_1_x" || _current_swing == "atk_jump_x"){
			return;//bail!
		} else if(!_plr.physics.is_on_floor()){
			return;//bail!
			set_player_melee_info(_plr, "atk_jump_x", 0, new Vec2(24,-8), new Vec2(64,56), 4)
		} else {
			set_player_melee_info(_plr, "atk_1_x", 32, new Vec2(32,-8), new Vec2(40,48), 4)
		}
		_plr.fsm.change("melee");
	}
}