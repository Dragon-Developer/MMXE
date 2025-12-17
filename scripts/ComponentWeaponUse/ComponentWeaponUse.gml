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
	"intro_end",
	"slide",
	"slide_end"
	]
	
	self.projectile_count = 0;
	self.added_melee_weapon = false;
	self.added_aimable_weapon = false;
	
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
		
		added_melee_weapon = false;
		
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
				
				switch(_proj_code.term){
					case("State Based"):
						_proj_code.init(self.get(ComponentPlayerMove))
					break;
					case("Melee"):
						if added_melee_weapon break;
						
						added_melee_weapon = true;
						get(ComponentPlayerMove).add_melee_state();
					break;
					case("Aimable"):
						if added_aimable_weapon break;
						
						added_aimable_weapon = true;
						get(ComponentPlayerMove).add_aimable_state();
					break;
				}
			})
		})
		
		variable_struct_remove(self, "added_melee_weapons")
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
		
		if(_wep.cost == 0){
			bar.barCount = 1;
		} else {
			bar.barCount = 2;
		}
		
		return _wep.weapon_palette;
	}
	
	self.step = function(){
		
		var _change_direction = self.input.get_input_pressed("switchRight") - self.input.get_input_pressed("switchLeft")
		
		if(_change_direction != 0 && array_length(self.weapon_list) > 1){
			self.change_weapon(self.current_weapon[0] + _change_direction)
			self.stock_shot = noone;
		} else if (_change_direction != 0){
			var _wep = {};
			
			with(_wep){
				script_execute(other.weapon_list[other.current_weapon[0]]);
			}
			
			if(_wep.cost == 0){
				bar.barCount = 1;
			} else {
				bar.barCount = 2;
			}
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
			
			//prepare shot data
			var _shot_index = 0;
			var _shot_code = {};
			
			with(_shot_code){
				script_execute(other.weapon_list[other.current_weapon[_id]]);
			}
			//log(_shot_code)
			
			//find out which charge level you have, if you can charge
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
			//get the projectile data
			var _shot_data = {};
			
			with(_shot_data){
				script_execute(_shot_code.data[_shot_index])
			}
			
			//apply stock shot
			if(self.stock_shot != noone){
				_shot_data = {};
				with(_shot_data){
					script_execute(other.stock_shot)
				}
			}
			
			//decrease weapon energy
			if(self.weapon_ammo[self.current_weapon[_id]] > 0){
				var _cost = 0;
				
				if is_array(_shot_code.cost)
					_cost = _shot_code.cost[_shot_index];
				else
					_cost = _shot_code.cost;
				
				//check if theres a projectile limit
				if(variable_struct_exists(_shot_data, "shot_limit")){
					if (_shot_data.shot_limit > self.projectile_count) {
						self.weapon_ammo[self.current_weapon[_id]] -= _cost;
					} else {
						
					}
					//log("pew " + string(self.projectile_count) + " " + string(_shot_data.shot_limit))
				} else 
					self.weapon_ammo[self.current_weapon[_id]] -= _cost;
			} else {
				//bail! you dont have weapon energy
				return;
			}
			
			//get what type of weapon this is [projectile, state based, melee, etc]
			var _type = _shot_data.term;
			
			//i love switch statements
			switch(_type){
				case("Projectile"):
					self.create_projectile(_shot_code, _shot_index, _input, _id);
				break;
				case("State Based"):
					get(ComponentPlayerMove).fsm.change(_shot_data.state_name)
				break;
				case("Melee"):
					_shot_data.set_player_state(get(ComponentPlayerMove), _shot_index);
				break;
				case("Aimable"):
					self.create_aimable_projectile(_shot_code, _shot_index, _input, _id);
					get(ComponentPlayerMove).fsm.change("aim")
				break;
			}
		}
	}
		
	self.create_aimable_projectile = function(_shot_code, _shot_index, _input, _id){
		//playing with fire here
		
		//log("REARAINGIUT BGSDBISDGUBSGUIYBYSFDTG USIDTGBISDFBGNTN*&IG")
		
		//get the name of the current animation
		var _anim_name = self.get_instance().components.get(ComponentAnimationShadered).animation.__animation;
		
		for(var i = 0; i < array_length(self.state_blacklist); i++){
			if(_anim_name == self.state_blacklist[i])
				return;
		}
		
		//turn the shot data into the actual projectile data
		var _shot_data = _shot_code.data[_shot_index];
		
		var _code = {};
		
		with(_code){
			script_execute(_shot_data)
		}
		
		//var _aim_direction = new Vec2()
		
		//self.get_instance().components.get(ComponentAnimationShadered).animation.__type = string_copy(_code.animation_append,2,256);
		
		var _dir = self.get_instance().components.find("animation").animation.__xscale;
		var _aim_dir = new Vec2(get(ComponentPlayerInput).get_input("right") - get(ComponentPlayerInput).get_input("left"), get(ComponentPlayerInput).get_input("down") - get(ComponentPlayerInput).get_input("up"))
		var _anim_name = "aim_shoot";
		
		if(abs(_aim_dir.x) < 0.2 && abs(_aim_dir.y) < 0.2)
			_aim_dir = new Vec2(_dir,0);
			
		if(_aim_dir.y >= 0.2)
			_anim_name += "_down"
		else if(_aim_dir.y <= -0.2)
			_anim_name += "_up"
		
		if(_aim_dir.x * _dir >= 0.2 || abs(_aim_dir.y) <= 0.2)
			_anim_name += "_forward"
		
		if(!get(ComponentPhysics).is_on_floor()){
			_anim_name += "_air"
		}
		
		log(_anim_name)
		
		self.publish("animation_play", {name: _anim_name})
		self.publish("animation_xscale", _aim_dir.x == 0 ? _dir : sign(_aim_dir.x))
		
		//set the time for shooting to end
		self.shot_end_time = CURRENT_FRAME + 15;
		
		var _x = self.get_instance().x;
		
		var _y = self.get_instance().y;
		
		if(_anim_name == "wall_slide"){
			_dir *= -1
		}
		
		//if we have an animator, add the shot offsets
		try{
			if(find("animation") != noone){
				//log("gon add offsets " + string( find("animation").get_shot_offsets()))
				var _offsets = find("animation").get_shot_offsets();
				_x += _offsets[0] * _dir;
				_y += _offsets[1];
				//log("added offsets")
			} else {
				//log(find("animation"))
			}
		} catch(_exception){
			
		}
			
		//create the projectile itself
		var _shot = noone
		
		
		var _tags = ["enemy"];
		
		if(global.server_settings.client_data.friendly_fire){
			for(var t = 0; t < instance_number(obj_player); t++){
				var _tag = "player" + string(t)
				
				if(get(ComponentDamageable).projectile_tags[0] != _tag)
					array_push(_tags, _tag);
			}
		}
		
		//log(string(_tags) + " are the projectile tagts")
		
		_shot = PROJECTILES.create_projectile(_x, _y, _dir, _shot_data, self, _tags);
		//_aim_dir = new Vec2(_aim_dir.x * _dir, _aim_dir.y);
		_shot.code.angle = _aim_dir;
		//log("my angle is" + string(_aim_dir.angle()))
		
		self.projectile_count++;
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
		var _shot_data = _shot_code.data[_shot_index];
		
		var _code = {};
		
		with(_code){
			script_execute(_shot_data)
		}
		
		//log(string_copy(_code.animation_append,2,256))
		
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
				//log("gon add offsets " + string( find("animation").get_shot_offsets()))
				var _offsets = find("animation").get_shot_offsets();
				_x += _offsets[0] * _dir;
				_y += _offsets[1];
				//log("added offsets")
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
		
		//log(string(_tags) + " are the projectile tagts")
		
		_shot = PROJECTILES.create_projectile(_x, _y, _dir, _shot_data, self, _tags);
		
		self.projectile_count++;
	}
} 