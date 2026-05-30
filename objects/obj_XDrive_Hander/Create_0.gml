start_time = CURRENT_FRAME;

_player = instance_nearest(0,0,obj_player)
_player = _player.components.get(ComponentPlayerMove);

interval = 10;

	_player.states.walk.speed *= 1.5;
	_player.states.dash.speed *= 1.5;
	_player.states.dash.interval *= 1.5;
	_player.states.wall_jump.wall_stick -= 5;
	_player.states.wall_jump.launch_lock -= 6;
	_player.states.wall_jump.strength += 1;
	_player.get(ComponentWeaponUse).charge.charge_time = [10, 30, 50, 70, 90, 110, 130]