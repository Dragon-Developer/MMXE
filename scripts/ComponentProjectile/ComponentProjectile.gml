function ComponentProjectile() : ComponentBase() constructor{
	//have a reference to a projectileWeaponData
	//if it doesnt exist, then end the step function early
	//otherwise, go ahead and run the step function of the ProjectileWeaponData
	//same with step, draw, etc
	//run the create step when the ProjectileWeaponData is recieved

	//self.weaponData = xBuster1Data;
	self.weaponData = global.weapon_data;
	self.weap = noone;
	
	
	self.init = function(){
		self.publish("animation_play", { name: "jump" });
		
		self.weap = self.weaponData();
		log(self.weap);
		self.weap.create();
		log(self.weap.create);
	}

	//you need this because specific stuff needs to happen. if you
	//REALLY want to move this to somewhere else, make sure to call
	//weaponData.create(); right after the data gets passed over
	self.on_register = function() {
		self.subscribe("set_weapon_data", function(_weapon_data) {
			weaponData = _weapon_data;
			//some projectiles dont need physics and such, so they arent here. 
			//i doubt all projectiles need the animation component too, but I
			//can see the need to have a default animation controller.
			weaponData.init();//init, not create
		});
		
		self.subscribe("animation_end", function() {
			//do something. will probably add functionality later.	
		});
	}
	
	self.step = function() {
		//if weaponData == noone return;
		self.weaponData.step();
	}
}