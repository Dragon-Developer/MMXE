on_spawn = function(_boss) {
	_boss.components.publish("character_set", "x");
	_boss.components.find("animation").set_subdirectories(["/normal"]);
	_boss.components.find("animation").max_queue_size = 0;
	_boss.components.get(ComponentDamageable).projectile_tags = ["enemy"]
	_boss.components.get(ComponentDamageable).death_function = function(){};
	
	//this might be shitty code but i dont care. 
	self.bossData.init(_boss.components.get(ComponentBoss));
	self.bossData.add_states(_boss.components.get(ComponentBoss));
}
repeat(spawn_times) {
	spawn();
}
instance_destroy();