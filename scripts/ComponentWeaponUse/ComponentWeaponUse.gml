function ComponentWeaponUse() : ComponentBase() constructor{
	self.shot_end_time = 0;
	self.current_weapon = [0,0,0,0];//i highly doubt these will change much at all during gameplay
	self.weapon_list = [
	xBuster,
	XenoMissile
	];
	self.stock_shot = noone;
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
	"leave",
	"teleport_in",
	"intro_end"
	]
	
	self.projectile_count = 0;
	
	self.serializer
		.addVariable("shot_end_time")
		.addVariable("current_weapon")
		.addVariable("weapon_list")
		
	self.init = function(){
		
	}
		
	self.on_register = function(){
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
			//need input to see if youre shooting
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
			//idk physics would be good for speed burner/charge kick
		});
	}
	
	self.set_weapons = function(_weapons){
		self.weapon_list = _weapons;
		
		if(!is_array(_weapons)){
			_weapons = [_weapons];
		}
		
		array_foreach(_weapons, function(_wep){
			var _code = {};
			
			with(_code){
				script_execute(_wep)
			}
			
			array_foreach(_code.data, function(_proj){
				
				var _proj_code = {};
			
				with(_proj_code){
					script_execute(_proj)
				}
				
				if(_proj_code.term == "State Based"){
					_proj_code.init(self.get(ComponentPlayerMove))
					log("state added!")
				}
			})
		})
	}
	
	self.change_weapon = function(_change){
		self.current_weapon[0] = _change;
		if(array_length(self.weapon_list) != 1)
		self.current_weapon[0] = (self.current_weapon[0] + array_length(self.weapon_list)) mod array_length(self.weapon_list)
		var _wep = {};
			
		with(_wep){
			script_execute(other.weapon_list[other.current_weapon[0]]);
		}
		if(_wep == undefined) return;
		//log(_wep)
		for(var i = 0; i < array_length(_wep.weapon_palette); i++){
			find("animation").set_palette_color(i, _wep.weapon_palette[i]);
		}
		
		return _wep.weapon_palette;
	}
	
	self.step = function(){
		
		var _change_direction = self.input.get_input_pressed("switchRight") - self.input.get_input_pressed("switchLeft")
		
		if(_change_direction != 0 && array_length(self.weapon_list) > 1){
			self.change_weapon(self.current_weapon[0] + _change_direction)
			self.stock_shot = noone;
		}
		
		if self.bar != noone {
			self.bar.barValues = [self.weapon_ammo[self.current_weapon[0]]]
			self.bar.barValueMax = [self.weapon_max_ammo]
		}
		
		if(self.charge != noone){
			self.charge.shoot_inputs = self.shoot_inputs;
		}
		
		var _anim_name = self.find("animation").animation.__animation;
		
		if(self.shot_end_time < CURRENT_FRAME){
			self.find("animation").animation.__type = "normal";
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
		if(self.input.get_input_pressed_raw(_input) || self.input.get_input_released(_input)){
			
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
			
			var _shot_data = {};
			with(_shot_data){
				script_execute(_shot_code.data[_shot_index])
			}
			
			if(self.stock_shot != noone){
				_shot_data = {};
				with(_shot_data){
					script_execute(other.stock_shot)
				}
			}
			
			var _type = _shot_data.term;
			
			if(_type == "Projectile" && self.projectile_count < _shot_data.shot_limit){
				self.create_projectile(_shot_code, _shot_index, _input, _id);
			} else if(_type == "State Based"){
				get(ComponentPlayerMove).fsm.change(_shot_data.state_name)
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
		
		//turn the shot data into the actual projectile data
		_shot_code = _shot_code.data[_shot_index];
		
		var _code = {};
		
		with(_code){
			script_execute(_shot_code)
		}
		
		log(string_copy(_code.animation_append,2,256))
		
		self.get_instance().components.get(ComponentAnimationShadered).animation.__type = string_copy(_code.animation_append,2,256);
		
		if(_anim_name == "idle"){
			self.publish("animation_play", {name: "shoot"})
		}
			
		if(_anim_name == "shoot"){
			self.publish("animation_play", {name: "shoot", reset: true})
		}
		
		
		
		//set the time for shooting to end
		self.shot_end_time = CURRENT_FRAME + 15;
		
		var _x = self.get_instance().x;
		
		var _y = self.get_instance().y;
		
		var _dir = self.get_instance().components.find("animation").animation.__xscale;
		
		if(_anim_name == "wall_slide"){
			_dir *= -1
		}
		
		//if we have an animator, add the shot offsets
		try{
			if(find("animation") != noone){
				log("gon add offsets " + string( find("animation").get_shot_offsets()))
				var _offsets = find("animation").get_shot_offsets();
				_x += _offsets[0] * _dir;
				_y += _offsets[1];
				log("added offsets")
			} else {
				//log(find("animation"))
			}
		} catch(_exception){
			
		}
			
		//create the projectile itself
		var _shot = noone
		
		
		var _tags = [];
		
		if(global.server_settings.client_data.friendly_fire){
			for(var t = 0; t < instance_number(obj_player); t++){
				var _tag = "player" + string(t)
				
				if(get(ComponentDamageable).projectile_tags[0] != _tag)
					array_push(_tags, _tag);
			}
		}
		
		log(string(_tags) + " are the projectile tagts")
		
		_shot = PROJECTILES.create_projectile(_x, _y, _dir, _shot_code, self, _tags);
		
		self.projectile_count++;
	}
} 