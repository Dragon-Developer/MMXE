function xBuster1() : ProjectileWeapon() constructor{
	self.data = xBuster1Data;//hmmm
	self.charge_time = 60;//i dont think mmxe uses this, but battle network has some busters charge faster than others
	self.animation_name = noone;//if its noone, then assume its _shoot. 
}

function xBuster1Data() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 3;//one full volley of lemons
	
	self.create = function(){
	}
	self.step = function(){
		//self.get_instance().x++;
		draw_sprite(spr_block1,0,self.get_instance().x,self.get_instance().y)
		log("starfish")
		self.publish("animation_play", { name: "walk" });
	}
	return self;//so this might be important
}