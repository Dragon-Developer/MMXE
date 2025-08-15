event_inherited();
entity_object = obj_player;
current_spawn = 0;
on_spawn = function(_player) {
	_player.components.get(ComponentAnimationPalette).set_subdirectories(
	[ "/normal"]);
	_player.components.get(ComponentPlayerInput).set_player_index(current_spawn);
	_player.components.publish("character_set", "weapon");
	_player.components.publish("character_set", global.player_character.image_folder);
	_player.components.publish("armor_set",
	[ "x1_helm","x1_body","x1_arms","x1_legs" ]);
	
	//create the charge graphics and make it a child
	
	var _charge = ENTITIES.create_instance(obj_charge);
	_charge.depth = _player.depth - 1;
	_charge.components.publish("character_set", "player");
	_player.components.get(ComponentNode).add_child(_charge.components.get(ComponentNode));
	_player.components.get(ComponentWeaponUse).weapon_list = global.player_character.weapons;
	_player.components.get(ComponentWeaponUse).weapon_ammo_max = global.player_character.weapon_ammo_max;
	_player.components.get(ComponentWeaponUse).weapon_ammo = array_create(array_length(global.player_character.weapons), global.player_character.weapon_ammo_max);
	//
	//set health to not 1
	_player.components.get(ComponentDamageable).set_health(global.player_data.health,global.player_data.max_health);
	_player.components.get(ComponentDamageable).invuln_time = 120;
	with(_player.components.get(ComponentDamageable)){
		self.death_function = function(){
			self.publish("death");
		}
	}
	_player.components.get(ComponentPlayerMove).apply_full_armor_set(_player.components.get(ComponentPlayerMove).armor_parts);
	
	if (current_spawn == global.local_player_index) {
		log("this is the player!")
		WORLD = ENTITIES.create_instance(obj_world);
		var _camera = ENTITIES.create_instance(obj_camera, x - GAME_W / 2, y - GAME_H / 2);
		_player.components.get(ComponentPlayerMove).camera = _camera;
		_camera.components.publish("target_set", _player);	
		_camera.components.get(ComponentHealthbar).compDamageable = _player.components.get(ComponentDamageable);
		_camera.components.get(ComponentHealthbar).barCount = 2;
		_camera.components.get(ComponentHealthbar).barOffsets = [new Vec2(12,78), new Vec2(28,78)];
		
		_camera.components.get(ComponentHealthbar).barValues = [_player.components.get(ComponentWeaponUse).weapon_ammo[_player.components.get(ComponentWeaponUse).current_weapon[0]]]
		_camera.components.get(ComponentHealthbar).barValueMax = [_player.components.get(ComponentWeaponUse).weapon_max_ammo]
		
		_player.components.get(ComponentWeaponUse).bar = _camera.components.get(ComponentHealthbar);
		_player.components.get(ComponentAnimationPalette).max_queue_size = 0;
		_player.components.get(ComponentPlayerInput).__BufferLength = global.settings.Input_Buffer;
		_player.components.get(ComponentPlayerInput).buffer_reset();
	}
	current_spawn++;
}
spawn_times = GAME.inputs.getTotalPlayers();