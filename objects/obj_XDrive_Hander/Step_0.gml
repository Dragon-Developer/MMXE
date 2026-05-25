if _player.get(ComponentWeaponUse).weapon_ammo[_player.get(ComponentWeaponUse).giga_index] <= 0 {
	instance_destroy(self)
	_player.states.walk.speed /= 1.5;
	_player.states.dash.speed /= 1.5;
	_player.states.dash.interval /= 1.5;
	_player.states.wall_jump.wall_stick += 5;
	_player.states.wall_jump.launch_lock += 6;
	_player.states.wall_jump.strength -= 1;
	_player.get(ComponentWeaponUse).charge.charge_time = [15, 70, 105, 145, 180, 220, 260]
	_player.get(ComponentDamageable).invuln_offset = CURRENT_FRAME + 1;
}

if CURRENT_FRAME mod interval == 0 {
	_player.get(ComponentWeaponUse).weapon_ammo[_player.get(ComponentWeaponUse).giga_index]--;
}


if CURRENT_FRAME mod 2 == 1{
	array_push(_player.find("animation").shaders, new BrightShader())
}else if(array_length(_player.find("animation").shaders) > 1)
	array_pop(_player.find("animation").shaders)