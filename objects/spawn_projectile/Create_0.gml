event_inherited();
entity_object = par_projectile;
dir = 1;
weaponData = xBuster11Data;
on_spawn = function(_shot) {
	_shot.components.publish("character_set", "weapon");
	_shot.components.get(ComponentAnimation).set_subdirectories(["/normal"]);
	_shot.components.get(ComponentAnimation).max_queue_size = 0;
	_shot.components.get(ComponentPhysics).grav = new Vec2(0, 0);
}
alarm[0] = 2;