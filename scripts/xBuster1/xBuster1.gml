function xBuster1() : ProjectileWeapon() constructor{
	log("i got constructed")
	self.data = xBuster1Data;//hmmm
	self.charge_time = 60;//i dont think mmxe uses this, but battle network has some busters charge faster than others
	self.animation_name = noone;//if its noone, then assume its _shoot. 
}

function xBuster1Data() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 3;//one full volley of lemons
	
	self.init = function(){
		//nothing here is being called wtf
		
		//prep the animator
		self.get_instance().components.get(ComponentAnimation).max_queue_size = 0;
		self.get_instance().components.get(ComponentAnimation).set_subdirectories(["/weapons"]);
		self.get_instance().components.publish("character_set", "x");
		self.publish("animation_play", { name: "shot_1" });
	}
	self.step = function(){
		self.get_instance().x++;
	}
}