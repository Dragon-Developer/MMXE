function ComponentWeaponUse() : ComponentBase() constructor{
	self.shot_end_time = 0;
	self.current_weapon = [0,0,0,0];//i highly doubt these will change much at all during gameplay
	self.weapon_list = [
	xBuster,
	XenoMissile
	];
	self.weapon_ammo = [28];
	self.weapon_max_ammo = 28;
	self.charge = noone;
	self.charge_time = [30, 105, 180, 255];
	self.shoot_inputs = ["shoot","shoot2","shoot3", "shoot4"]
	self.bar = noone;
	
	self.state_blacklist = [
	"death",
	"mach_dash",
	"mach_hold",
	"hurt",
	"intro",
	"complete",
	"outro",
	"leave"
	]
	
	self.serializer
		.addVariable("shot_end_time")
		.addVariable("current_weapon")
		.addVariable("weapon_list")
		
	self.on_register = function(){
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
			//need input to see if youre shooting
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
			//idk physics would be good for speed burner/charge kick
		});
	}
	
	self.change_weapon = function(_change){
		self.current_weapon[0] = _change;
		self.current_weapon[0] = (self.current_weapon[0] + array_length(self.weapon_list)) mod array_length(self.weapon_list)
		var _wep = {};
			
		with(_wep){
			script_execute(other.weapon_list[other.current_weapon[0]]);
		}
		if(_wep == undefined) return;
		log(_wep)
		for(var i = 0; i < array_length(_wep.weapon_palette); i++){
			find("animation").set_palette_color(i, _wep.weapon_palette[i]);
		}
		
		return _wep.weapon_palette;
	}
	
	self.step = function(){
		
		var _change_direction = self.input.get_input_pressed("switchRight") - self.input.get_input_pressed("switchLeft")
		
		if(_change_direction != 0){
			self.change_weapon(self.current_weapon[0] + _change_direction)
		}
		
		if self.bar != noone {
			self.bar.barValues = [self.weapon_ammo[self.current_weapon[0]]]
			self.bar.barValueMax = [self.weapon_max_ammo]
		}
		
		if(self.charge != noone){
			self.charge.shoot_inputs = self.shoot_inputs;
		}
		
		var _anim_name = self.get_instance().components.find("animation").animation.__animation;
		
		if(self.shot_end_time < CURRENT_FRAME){
			self.get_instance().components.find("animation").animation.__type = "normal";
			if(_anim_name == "shoot"){
				self.publish("animation_play", { 
					name: "idle"
				});
			}
		} else {
		
			if(_anim_name == "idle"){
				self.publish("animation_play", { 
					name: "shoot"
				});
			}
		}
		
		for(var g = 0; g < array_length(self.shoot_inputs);g++){
			self.shoot(self.shoot_inputs[g], g);
		}
	}
	
	self.shoot = function(_input, _id){
		if(self.input.get_input_pressed(_input) || self.input.get_input_released(_input)){
			
			var _shot_index = 0;
			var _shot_code = {};
			
			with(_shot_code){
				script_execute(other.weapon_list[other.current_weapon[_id]]);
			}
			//log(_shot_code)
			
			if(self.input.get_input_released(_input) && self.charge != noone){
				//nobody said i was a CLEAN coder
				
				if(self.charge.charging){
					for(var p = 0; p < array_length(charge_time); p++){
						
						if(self.charge.start_time + charge_time[p] < CURRENT_FRAME
						&& _shot_code.charge_limit >= p + 1){
							_shot_index = p + 1;
						}
					}
				}
				if(_shot_index == 0){
					return;
				}
			}
			var _type = _shot_code.term;
			log(_type)
			if(_type == "Projectile"){
				self.create_projectile(_shot_code, _shot_index, _input, _id);
			} 
		}
	}
			
	self.create_projectile = function(_shot_code, _shot_index, _input, _id){
		//playing with fire here
		
		//get the name of the current animation
		var _anim_name = self.get_instance().components.get(ComponentAnimationShadered).animation.__animation;
		
		for(var i = 0; i < array_length(self.state_blacklist); i++){
			if(_anim_name == self.state_blacklist[i])
				return;
		}
		
		//if the shot animation is shoot, go ahead and do animation stuff
		if(_shot_code.animation_append == "_shoot"){
			if(_anim_name == "idle"){
				self.publish("animation_play", {name: "shoot"})
			}
			
			if(_anim_name == "shoot"){
				self.publish("animation_play", {name: "shoot", reset: true})
			}
			self.get_instance().components.get(ComponentAnimationShadered).animation.__type = "shoot";
		}
		
		//turn the shot data into the actual projectile data
		_shot_code = _shot_code.data[_shot_index];
		
		//set the time for shooting to end
		self.shot_end_time = CURRENT_FRAME + 15;
		
		var _x = self.get_instance().x;
		
		var _y = self.get_instance().y;
			
		//create the projectile itself
		var _shot = noone
		
		var _dir = self.get_instance().components.find("animation").animation.__xscale;
		
		if(_anim_name == "wall_slide"){
			_dir *= -1
		}
		
		_shot = PROJECTILES.create_projectile(_x, _y, _dir, _shot_code);
		
		//old method
		//_shot = instance_create_depth(self.get_instance().x,self.get_instance().y,self.get_instance().depth, spawn_projectile);
		
		//set the projectile's direction to the player's
		//_shot.dir = self.get_instance().components.find("animation").animation.__xscale;
		
		//flip the direction if wallsliding
		if(_anim_name == "wall_slide"){
			//_shot.dir*= -1
		}
			
		//set the projectile's data to _shot_data
		//_shot.weaponData = _shot_code;
	}
	
	self.apply_shot_offsets = function(_shot){
		log(self.get_instance().components.find("animation").animation.get_props())
		log("QWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOP END")
		//var _xOff = self.get_instance().components.find("animation").animation.shot_offset_x;
		//var _yOff = self.get_instance().components.find("animation").animation.shot_offset_y;
		
		//_shot.x += _xOff;
		//_shot.y += _yOff;
	}
} 