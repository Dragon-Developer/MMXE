function ComponentWeaponUse() : ComponentBase() constructor{
	//this is where weapons are used. 
	
	/*
		so uhh i have no idea how im gonna make this work. 
		
		ill start with inputs and tacking on the shoot animation.
	*/
	
	//dark said no int based timers because we plastered them everywhere.
	//current_time is in milliseconds!
	self.shot_end_time = 0;
	current_weapon = 0;//the weapon data, not the projectile or melee data.
	self.weapon_list = [xBuster1Data];
	
	self.init = function(){
		current_weapon = 0;//DONT ADD THE () IT WILL CAUSE ISSUES
	}
	
	self.on_register = function(){
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
			//need input to see if youre shooting
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
			//idk physics would be good for speed burner/charge kick
		});
	}
	
	self.step = function(){
		if(self.shot_end_time < CURRENT_FRAME){
			//probably shouldnt manually set this but meh
			self.get_instance().components.get(ComponentAnimation).animation.__type = "normal";
			var _anim_name = self.get_instance().components.get(ComponentAnimation).animation.__animation;
			if(_anim_name == "shoot"){
				self.publish("animation_play", { 
					name: "idle"
				});
			}
		} else { //can use the time when you have the shoot animation up 
			var _anim_name = self.get_instance().components.get(ComponentAnimation).animation.__animation;
		
			if(_anim_name == "idle"){
				self.publish("animation_play", { 
					name: "shoot"
				});
			}
		}
		
		if(self.input.get_input_pressed("shoot")){
			//set the time for shooting to end. it's an offset so idk
			self.shot_end_time = CURRENT_FRAME + 24;
			self.get_instance().components.get(ComponentAnimation).animation.__type = "shoot";
			
			//if youre idle, do the shooting animation. 
			var _anim_name = self.get_instance().components.get(ComponentAnimation).animation.__animation;
			if(_anim_name == "idle"){
				self.publish("animation_play_at_loop", { 
					name: "shoot",
					frame: 0
				});
			}
			
			//TEMP - REMOVE WHEN BETTER METHOD IS FOUND
			global.weapon_data = self.weapon_list[self.current_weapon];
			
			//make the projectile lol
			var _inst = ENTITIES.create_instance(par_projectile);
			//shot offsets need to be applied. dark has something he was cookin on so i will leave it be
			_inst.x = self.get_instance().x;
			_inst.y = self.get_instance().y;
			//every projectile is the same object. melee attacks would be a seperate object
			//so you can do seperate things depending on what hits what
			
			//_inst.components.get(ComponentProjectile).weaponData = self.current_weapon.data;
			
			// the above code does not work. ill just make the projectile data a global
			// variable until i can fix it later or dark/gacel (the guys with expereince)
			// come up with a better fix
		}
	}
}