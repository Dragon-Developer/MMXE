function ComponemtBoss() : ComponentEnemy() constructor{
	self.has_done_dialouge = false;
	
	self.init = function(){
		self.publish("animation_play", { name: "idle" });
		
	}
	
	self.step = function() {
		if(instance_exists(obj_dialouge)) return;
		
		if EnemyEnum == noone || EnemyEnum == undefined return;//
		if (!variable_struct_exists(
		EnemyEnum, 
		"step")) 
			return;
		EnemyEnum.step(self);
		//self.get_constructor();
	}
	
	self.on_register = function() {
		self.subscribe("animation_end", function() {
			//do something. will probably add functionality later.	
		});
		self.subscribe("enemy_data_set", function(_dir){
			EnemyData = _dir;
			EnemyEnum = new EnemyData();
			EnemyEnum.setComponent(self);
			EnemyEnum.init(self.get_instance());	
			
			
			with(self.get_instance())
			{
				var _txt = instance_create_depth(x,y,depth, obj_dialouge_spawner);
				_txt.dialouge = EnemyEnum.dialouge;
			}
		});
	}
}