function ComponentProjectile() : ComponentBase() constructor{
	//have a reference to a projectileWeaponData
	//if it doesnt exist, then end the step function early
	//otherwise, go ahead and run the step function of the ProjectileWeaponData
	//same with step, draw, etc
	//run the create step when the ProjectileWeaponData is recieved

	self.weaponData = xBuster11Data;
	self.weaponCreate = noone;
	
	
	self.init_time = -1;
	self.ded = false;
	self.death_requirements = [
	function(){
		var _inst = self.get_instance();
		
		if(!instance_exists(_inst)){
			log("shit");
			return true;
		}
		// i need to get the sprite width and height so i can account them when deleting projectiles.
		// currently, i just give a quarter of the screen as leeway so sprites can leave the viewport
		// before dying
		if(!is_undefined(global.server))
		return (
			//this should be the camera because the player is never perfectly in the middle
			abs(instance_nearest(_inst.x, _inst.y, obj_player).x - _inst.x + GAME_W / 2) > GAME_W ||
			abs(instance_nearest(_inst.x, _inst.y, obj_player).y - _inst.y + GAME_H / 2) > GAME_H 
		)
		else
		return (
			//this should be the camera because the player is never perfectly in the middle
			abs(instance_nearest(_inst.x, _inst.y, obj_camera).x - _inst.x + GAME_W / 2) > GAME_W / 1.5 ||
			abs(instance_nearest(_inst.x, _inst.y, obj_camera).y - _inst.y + GAME_H / 2) > GAME_H / 1.5
		)
	},
	function(){
		var _inst = self.get_instance();
		if(!instance_exists(_inst)){
			log("shit");
			return true;
		}
		return _inst.components.get(ComponentPhysics).check_place_meeting(_inst.x,_inst.y, obj_reflect_block);
	}
	];
	
	self.hurtable_tag = "enemy";// the generic projectile type. used for hurtables
	
	self.serializer = new NET_Serializer(self);
	self.serializer
		.addVariable("weaponData")
		.addVariable("weaponCreate");
	
	//refreshed myself on structs. gonna see about making it work now.
	
	self.init = function(){
		self.publish("animation_play", { name: "shot" });
		if(self.get_instance().mask_index == -1){
				self.get_instance().mask_index = spr_player_mask;	
			}
		self.init_time = CURRENT_FRAME;
		self.get_instance().components.get(ComponentPhysics).grav = new Vec2(0, 0);
		self.get_instance().components.get(ComponentPhysics).velocity = new Vec2(0, 0);
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
			self.publish("animation_xscale", _dir)
			weaponCreate.dir = _dir;
		});
	}
	
	self.step = function() {
		self.verify_can_die();
		
		if(!instance_exists(self.get_instance())){
			log("shit");
			return true;
		}
		
		if(variable_instance_exists(self.get_instance(), "components")){
			if(variable_instance_exists(self.get_instance().components, "_id"))
				log(string(self.get_instance().components._id) + " is the id for a projectile")
		}
		if weaponCreate == noone || weaponCreate == undefined return;//
		if (!variable_struct_exists(
		weaponCreate, 
		"step")) 
			return;
		try{
			weaponCreate.step(self.get_instance());
		} catch(_exception){
			log(_exception)
		}
	}
	
	self.draw = function(){
		if (!variable_struct_exists(
		weaponCreate, 
		"draw")) 
			return;
		try{
			weaponCreate.draw(self.get_instance());
		} catch(_exception){
			log(_exception)
		}
	}
	
	self.verify_can_die = function(){
		array_foreach(self.death_requirements, function(_req){
			if(_req())
				ENTITIES.destroy_instance(self.get_instance());
		});
	}
}