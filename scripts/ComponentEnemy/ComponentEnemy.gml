function ComponentEnemy() : ComponentBase() constructor{
	self.health = 1;//because I dont want to manually get a reference to the damageable
	self.contact_damage = 1;//the amount of contact damage enemies deal
	
	self.init = function(){
		self.publish("animation_play", { name: "idle" });
		get(ComponentDamageable).death_function = function(){
			var _inst = self.get_instance();
			WORLD.spawn_particle(new ExplosionParticle(_inst.x, _inst.y,1))
			WORLD.play_sound("Explosion");
			ENTITIES.destroy_instance(_inst)
		}
	}
	
	self.EnemyData = BaseEnemy;//enemy 
	self.EnemyEnum = noone;

	//you need this because specific stuff needs to happen. if you
	//REALLY want to move this to somewhere else, make sure to call
	//weaponData.create(); right after the data gets passed over
	self.on_register = function() {
		self.subscribe("animation_end", function() {
			//do something. will probably add functionality later.	
		});
		self.subscribe("enemy_data_set", function(_dir){
			EnemyData = _dir;
			EnemyEnum = new EnemyData();
			EnemyEnum.setComponent(self);
			self.health = EnemyEnum.health;
			EnemyEnum.init(self.get_instance());	
			self.get_instance().components.get(ComponentDamageable).health = self.health;
			self.get_instance().components.get(ComponentDamageable).health_max = self.health;
		});
	}
	
	self.step = function() {
		if EnemyEnum == noone || EnemyEnum == undefined return;//
		if (!variable_struct_exists(
		EnemyEnum, 
		"step")) 
			return;
		EnemyEnum.step(self);
		self.get_constructor();
	}
}