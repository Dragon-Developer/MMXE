function ComponentProjectile() : ComponentBase() constructor{
	//have a reference to a projectileWeaponData
	//if it doesnt exist, then end the step function early
	//otherwise, go ahead and run the step function of the ProjectileWeaponData
	//same with step, draw, etc
	//run the create step when the ProjectileWeaponData is recieved

	self.weaponData = xBuster11Data;
	self.weaponCreate = noone;
	
	
	self.serializer = new NET_Serializer(self);
	self.serializer
		.addVariable("weaponData")
		.addVariable("weaponCreate");
	
	//refreshed myself on structs. gonna see about making it work now.
	
	self.init = function(){
		self.publish("animation_play", { name: "shot" });
		
	}

	//you need this because specific stuff needs to happen. if you
	//REALLY want to move this to somewhere else, make sure to call
	//weaponData.create(); right after the data gets passed over
	self.on_register = function() {
		self.subscribe("animation_end", function() {
			//do something. will probably add functionality later.	
		});
		self.subscribe("weapon_data_set", function(_dir) {
			//log(weaponData);
			weaponCreate = new weaponData();
			weaponCreate.general_init(self);
			weaponCreate.create(self.get_instance());	
			weaponCreate.dir = _dir;
		});
	}
	
	self.step = function() {
		//log(self.)
		if weaponCreate == noone || weaponCreate == undefined return;//
		if (!variable_struct_exists(
		weaponCreate, 
		"step")) 
			return;
		weaponCreate.step(self.get_instance());
	}
}