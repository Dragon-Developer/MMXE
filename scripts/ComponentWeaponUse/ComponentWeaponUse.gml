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
			var _shot = instance_create_depth(self.get_instance().x,self.get_instance().y,self.get_instance().depth, spawn_projectile);
			//we need to pass the direction over. i dont know how as of this moment
		}
	}
}