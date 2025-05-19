event_inherited();
entity_object = par_projectile;
on_spawn = function(_player) {
	_player.components.get(ComponentAnimation).set_subdirectories(["/normal"]);
	_player.components.publish("character_set", "weapon");
		_player.components.get(ComponentAnimation).max_queue_size = 0;
}