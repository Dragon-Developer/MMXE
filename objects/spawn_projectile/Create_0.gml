event_inherited();
entity_object = par_projectile;
on_spawn = function(_player) {
	_player.components.get(ComponentAnimation).set_subdirectories(["/weapons", "/normal"]);
	_player.components.publish("character_set", "x");
		_player.components.get(ComponentAnimation).max_queue_size = 0;
}