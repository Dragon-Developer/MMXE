event_inherited();
entity_object = par_projectile;
dir = 1;
weaponData = xBuster1Data;
on_spawn = function(_shot) {
	_shot.components.publish("character_set", "weapon");
	_shot.components.get(ComponentAnimation).set_subdirectories(["/normal"]);
	_shot.components.get(ComponentAnimation).max_queue_size = 0;
}
alarm[0] = 2;