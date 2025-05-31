function ComponentEnemy() : ComponentBase() constructor{
	self.health = -1;//because I dont want to manually get a reference to the damageable
	
	self.init = function(){
		self.publish("animation_play", { name: "idle" });
	}
}