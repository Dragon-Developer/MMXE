function ComponentEnemy() : ComponentBase() constructor{
	self.health = -1;//because I dont want to manually get a reference to the damageable
	
	self.init = function(){
		self.publish("animation_play", { name: "idle" });
	}
	
	self.EnemyData = BaseEnemy;//enemy 
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
		self.subscribe("enemy_data_set", function(_dir){
			EnemyData = _dir;
			EnemyEnum = new EnemyData();
			EnemyEnum.setComponent(self);
			EnemyEnum.init(self.get_instance());	
			
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