function ComponentEnemy() : ComponentBase() constructor{
	self.health = -1;//because I dont want to manually get a reference to the damageable
	
	self.init = function(){
		self.publish("animation_play", { name: "idle" });
	}
	
	self.EnemyData = xBuster11Data;//enemy 
	self.EnemyEnum = noone;
	
	
	self.serializer = new NET_Serializer(self);
	self.serializer
		.addVariable("EnemyData")
		.addVariable("EnemyEnum")
		.addVariable("health");

	//you need this because specific stuff needs to happen. if you
	//REALLY want to move this to somewhere else, make sure to call
	//weaponData.create(); right after the data gets passed over
	self.on_register = function() {
		self.subscribe("animation_end", function() {
			//do something. will probably add functionality later.	
		});
		self.subscribe("enemy_data_set", function(_dir) {
			//log(weaponData);
			EnemyEnum = new EnemyData();
			EnemyEnum.general_init(self);
			EnemyEnum.create(self.get_instance());	
			EnemyEnum.dir = _dir;
		});
	}
	
	self.step = function() {
		//log(self.)
		if EnemyEnum == noone || EnemyEnum == undefined return;//
		if (!variable_struct_exists(
		EnemyEnum, 
		"step")) 
			return;
		EnemyEnum.step(self.get_instance());
	}
}