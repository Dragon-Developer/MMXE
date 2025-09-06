self.spawn_boss = function(){
	log("spawning boss")
	var _boss = ENTITIES.create_instance(par_boss);
	log("boss entity made")
	_boss.x = x;
	_boss.y = y;
	log("boss positioned")
	//_boss.components.get(ComponentBoss).boss_data = self.boss;
	_boss.components.publish("character_set", "x");
	log("boss sprites loaded")
	_boss.components.get(ComponentAnimation).set_subdirectories(["/normal"]);
	log("boss directories loaded")
	_boss.components.get(ComponentAnimation).max_queue_size = 0;
	_boss.components.get(ComponentPhysics).grav = new Vec2(0, 0);
	log("boss physics set")
	_boss.components.get(ComponentDamageable).projectile_tags = ["enemy"]
	_boss.components.get(ComponentDamageable).death_function = function(){};
	
	//this might be shitty code but i dont care. 
	self.boss.add_states(_boss.components.get(ComponentBoss));
	log("boss states loaded")
}

self.boss = new FlameStagBoss();