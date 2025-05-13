function xBuster1() : ProjectileWeapon() constructor{
	self.data = xBuster1Data;//hmmm
	self.charge_time = 60;//i dont think mmxe uses this, but battle network has some busters charge faster than others
	self.animation_name = noone;//if its noone, then assume its _shoot. 
}

function xBuster1Data() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 3;//one full volley of lemons
	
	self.create = function(){
		self.get_instance().components.get(ComponentAnimation).max_queue_size = 0;
		self.get_instance().components.get(ComponentAnimation).set_subdirectories(["/normal","/weapons"]);
		self.get_instance().components.publish("character_set", "x");
	}
	self.step = function(){
		self.get_instance().x++;
		self.publish("animation_play", { name: "idle" });
	}
	return self;//so this might be important
}