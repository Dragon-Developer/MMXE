function ComponentWeaponUse() : ComponentBase() constructor{
	self.shot_end_time = 0;
	self.current_weapon = [0,0,0,0];//i highly doubt these will change much at all during gameplay
	self.weapon_list = [
	xBuster,
	XenoMissile
	];
	self.stock_shot = noone;
	self.weapon_ammo = [0];
	self.weapon_max_ammo = global.player_data.weapon_energy
	self.weapon_use_rate = 1;
	self.weapon_palette = undefined;
	self.charge = undefined;
	self.charge_time = [30, 105, 180, 255];
	self.shoot_inputs = ["shoot","shoot2","shoot3", "shoot4"]
	self.bar = noone;
	
	self.supercharged = false;
	self.supercharged_amount = 0;
	
	self.damage_increase = 0;
	self.giga_index = -1;
	
	self.state_blacklist = [
		"death",
		"mach_dash",
		"mach_hold",
		"hurt",
		"intro",
		"intro_end",
		"teleport_in",
		"complete",
		"outro",
		"leave",
		"teleport_in",
		"intro_end",
		"slide",
		"slide_end",
		"genki_dama",
		"melee",
		"melee_end",
		"variable_dash",
		"variable_dash_start",
		"ceil_cling",
		"ceil_cling_shoot"
	]
	
	self.projectile_count = 0;
	self.added_melee_weapon = false;
	self.added_aimable_weapon = false;
	self.refire_time = 0;
	
	self.serializer
		.addVariable("shot_end_time")
		.addVariable("current_weapon")
		.addVariable("weapon_list")
		
	self.init = function(){
		self.charge = get(ComponentNode).add_child(ENTITIES.create_instance(obj_charge));
		self.charge = self.charge.components.get(ComponentCharge)
		self.charge.node_parent = get(ComponentNode);
		self.charge.input = get(ComponentPlayerInput);
		self.charge.publish("character_set", "player");
		self.charge.current_weapon = xBuster;
		self.current_weapon = [0,clamp(1, 0, array_length(global.availible_characters[global.character_index].weapons)),array_length(global.availible_characters[global.character_index].weapons) - 1,array_length(global.availible_characters[global.character_index].weapons) - 2];
		if(self.current_weapon[1] < 0)self.current_weapon[1] = 0;
		if(self.current_weapon[2] < 0)self.current_weapon[2] = 0;
		if(self.current_weapon[3] < 0)self.current_weapon[3] = 0;
 		self.weapon_palette = global.player_character[0].default_palette;
		
		if(array_length(global.availible_characters[global.character_index].weapons) <= 0){
			self.current_weapon = [0,0,0,0];
		}
	}
		
	self.on_register = function(){
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentInputBase();
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
		});
		
		self.subscribe("took_damage", function(_damage) {
			if(giga_index != -1){
				self.heal_ammo(max(round(_damage / 4), 1), giga_index)
			}
			//log("YEOW")
		});
	}
	
	self.heal_ammo = function(_amount, _index = current_weapon[0]){
		if(weapon_ammo[_index] < weapon_max_ammo)
			weapon_ammo[_index] += _amount;
	}
	
	self.set_weapons = function(_weapons){
		self.weapon_list = _weapons;
		weapon_ammo = [];
		
		added_melee_weapon = false;
		
		if(!is_array(_weapons)){
			_weapons = [_weapons];
		}
		
		array_foreach(_weapons, function(_wep, _index){
			var _code = {};
			
			with(_code){
				script_execute(_wep)
			}
			
			if(_code.giga)
				giga_index = _index
			
			array_foreach(_code.data, function(_proj){
				
				var _proj_code = {};
			
				with(_proj_code){
					script_execute(_proj)
				}
				
				array_push(weapon_ammo, global.player_data.weapon_energy);
				
				//if(_proj.code.)
				
				switch(_proj_code.term){
					case("State Based"):
						_proj_code.init(self.get(ComponentPlayerMove))
					break;
					case("Melee"):
						if added_melee_weapon break;
						
						added_melee_weapon = true;
						add_melee_state(get(ComponentPlayerMove));
					break;
					case("Aimable"):
						if added_aimable_weapon break;
						
						added_aimable_weapon = true;
						add_aimable_state(get(ComponentPlayerMove));
					break;
				}
			})
		})
		
		variable_struct_remove(self, "added_melee_weapons")
	}
	
	self.change_weapon = function(_change, _index = 0){
		var _old_change = self.current_weapon[_index];
		self.current_weapon[_index] = _change;
		if(array_length(self.weapon_list) != 1)
		self.current_weapon[_index] = (self.current_weapon[_index] + array_length(self.weapon_list)) mod array_length(self.weapon_list)
		var _wep = {};
			
		with(_wep){
			script_execute(other.weapon_list[other.current_weapon[_index]]);
		}
		if(_wep == undefined) return;
		
		if(_wep.not_selectable) {
			self.change_weapon(self.current_weapon[_index] + sign(_change - _old_change))
			return
		}
		
		self.weapon_palette = _wep.weapon_palette;
		//log(_wep)
		if(_index == 0)
			for(var i = 0; i < array_length(_wep.weapon_palette); i++){
				find("animation").set_palette_color(i, _wep.weapon_palette[i]);
			}
		
		if(_index == 0)
			if(_wep.cost == 0){
				bar.barCount = 1;
			} else {
				bar.barCount = 2;
			}
			if(giga_index != -1)
				bar.barCount++;
		
		return _wep.weapon_palette;
	}
	
	self.step = function(){
		if (self.timescale != 1) self.timescale = 1
		
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
			
			if(giga_index != -1)
				bar.barCount++;
		}
		
		if self.bar != noone {
			self.bar.barValues = [self.weapon_ammo[self.current_weapon[0]]]
			self.bar.barValueMax = [self.weapon_max_ammo]
			
			if(giga_index != -1){
				if(bar.barCount == 2){
					self.bar.barValues = [self.weapon_ammo[self.giga_index]]
					self.bar.barValueMax = [self.weapon_max_ammo]
					bar.barTypes = ["gigabar"]
				} else {
					array_push(self.bar.barValues, self.weapon_ammo[self.giga_index])
					array_push(self.bar.barValueMax, self.weapon_max_ammo)
					bar.barTypes = ["healthbar", "gigabar"]
				}
			}
		}
		
		if(self.charge != noone){
			self.charge.shoot_inputs = self.shoot_inputs;
			self.charge.current_weapon = self.weapon_list[self.current_weapon[0]];
			self.charge_time = self.charge.charge_time;
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
		
		if(array_contains(state_blacklist, get(ComponentPlayerMove).fsm.get_current_state())) return;
		
		for(var g = 0; g < array_length(self.shoot_inputs);g++){
			self.check_shooting(self.shoot_inputs[g], g);
		}
	}
	
	self.check_shooting = function(_input, _id){
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
						_shot_index = clamp(p + 1, 0, self.charge.charge_limit);
					}
				}
			}
			if(_shot_index == 0){
				return;
			}
		}
		
		if(supercharged){
			_shot_index += 3
		}
		
		var _shot_data = {};
			
		with(_shot_data){
			script_execute(_shot_code.data[clamp(_shot_index, 0, array_length(_shot_code.data) - 1)])
		}
		
		if (_shot_data.shot_limit <= self.projectile_count) return;
			
		//get what type of weapon this is [projectile, state based, melee, etc]
		var _type = _shot_data.term;
			
		//i love switch statements
		switch(_type){
			case("Projectile"):
				if self.shoot_check(_input, _id,_shot_data ,_shot_code)
					self.create_standard_projectile(_shot_code, _shot_index, _input, _id);
			break;
			case("Flamethrower"):
				if(CURRENT_FRAME > self.refire_time)//sue me
					if self.shoot_check_repeated(_input, _id,_shot_data ,_shot_code)
						self.create_standard_projectile(_shot_code, _shot_index, _input, _id);
			break;
			case("State Based"):
				if self.shoot_check(_input, _id,_shot_data ,_shot_code){
					get(ComponentPlayerMove).fsm.change(_shot_data.state_name)
				}
			break;
			case("Melee"):
				if(self.input.get_input_pressed_raw(_input) || self.input.get_input_released(_input))
					_shot_data.set_player_state(get(ComponentPlayerMove), _shot_index);
			break;
			case("Aimable"):
				if(self.input.get_input(_input) && CURRENT_FRAME > self.refire_time){
					self.create_aimable_projectile(_shot_code, _shot_index, _input, _id);
					if(get(ComponentPlayerMove).fsm.get_current_state() != "aim")
						get(ComponentPlayerMove).fsm.change("aim")
					get(ComponentPlayerMove).timer = CURRENT_FRAME;
				}
			break;
		}
	}
		
	self.shoot_check = function(_input, _id, _shot_data, _shot_code){
		if(self.input.get_input_pressed_raw(_input) || self.input.get_input_released(_input)){
			return general_shooting_check(_input, _id, _shot_data, _shot_code);
		}
		return false;
	}
	
	self.shoot_check_repeated = function(_input, _id, _shot_data, _shot_code){
		if(self.input.get_input(_input)){
			var _possible = general_shooting_check(_input, _id, _shot_data, _shot_code);
			
			log(_shot_data.shot_delay)
			
			if (_possible) self.refire_time = CURRENT_FRAME + _shot_data.shot_delay;

			return _possible
		}
		return false;
	}
	
	self.general_shooting_check = function(_input, _id, _shot_data, _shot_code){
		//apply stock shot
		if(self.stock_shot != noone){
			_shot_data = {};
			log("stock shot!")
			with(_shot_data){
				script_execute(other.stock_shot)
			}
		}
			
		//decrease weapon energy
		
		var _cost = 0;
				
			if is_array(_shot_code.cost)
				_cost = _shot_code.cost[_shot_index];
			else
				_cost = _shot_code.cost;
				
		var _req = 0;
		
		if(_shot_code.giga)
			_req = _cost;
				
		if(self.weapon_ammo[self.current_weapon[_id]] >= _req){
			if(global.debug) return true;
			
				
			//check if theres a projectile limit
			if(variable_struct_exists(_shot_data, "shot_limit")){
				self.weapon_ammo[self.current_weapon[_id]] -= _cost * self.weapon_use_rate;
				//log("pew " + string(self.projectile_count) + " " + string(_shot_data.shot_limit))
			} else 
				self.weapon_ammo[self.current_weapon[_id]] -= _cost * self.weapon_use_rate;
		} else {
			//bail! you dont have weapon energy
			return false;
		}
		return true;	
	}
		
	self.create_aimable_projectile = function(_shot_code, _shot_index, _input, _id){
		//apply stock shot
		if(self.stock_shot != noone){
			_shot_data = {};
			log("stock shot!")
			with(_shot_data){
				script_execute(other.stock_shot)
			}
		}
		
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
		
		//log(_anim_name)
		
		self.publish("animation_play", {name: _anim_name})
		self.publish("animation_xscale", _aim_dir.x == 0 ? _dir : sign(_aim_dir.x))
		
		//set the time for shooting to end
		self.shot_end_time = CURRENT_FRAME + 15;
		
		var _shot = self.create_shot(_shot_data, _shot_index, _input, _id, _anim_name);
		
		//_aim_dir = new Vec2(_aim_dir.x * _dir, _aim_dir.y);
		_shot.code.angle = _aim_dir;
		//log("my angle is" + string(_aim_dir.angle()))
		
		refire_time = CURRENT_FRAME + _shot.code.shot_delay;
	}
		
	self.create_standard_projectile = function(_shot_code, _shot_index, _input, _id){
		//playing with fire here
		
		//get the name of the current animation
		var _anim_name = self.get_instance().components.get(ComponentAnimationShadered).animation.__animation;
		
		for(var i = 0; i < array_length(self.state_blacklist); i++){
			if(_anim_name == self.state_blacklist[i])
				return;
		}
		
		//turn the shot data into the actual projectile data
		var _shot_data = _shot_code.data[clamp(_shot_index, 0, array_length(_shot_code.data) - 1)]
		
		//apply stock shot
		if(self.stock_shot != noone){
			_shot_data = self.stock_shot;
			log("stock shot!")
			self.stock_shot = noone;
		}
		
		var _code = {};
		
		with(_code){
			script_execute(_shot_data)
		}
		
		//log(string_copy(_code.animation_append,2,256))
		if(_code.set_animation_instead){
			self.publish("animation_play", {name: _code.animation_append})
			if(get(ComponentPlayerMove))
				get(ComponentPlayerMove).fsm.change("shoot_anim")
		} else {
			if(_code.animation_append != "")
			self.get_instance().components.get(ComponentAnimationShadered).animation.__type = string_copy(_code.animation_append,2,256);
		
			if(_anim_name == "idle"){
				self.publish("animation_play", {name: "shoot"})
			}
		}
			
		if(_code.animation_append != "")
		if(_anim_name == "shoot"){
			self.publish("animation_play", {name: "shoot", reset: true})
		} else if(_anim_name == "ladder_move" || _anim_name == "ladder_exit" || _anim_name == "ladder_enter"){
			self.publish("animation_play", {name: "ladder_shoot"})
		}
		
		self.create_shot(_shot_data, _shot_index, _input, _id, _anim_name);
	}
	
	self.create_shot = function(_shot_data, _shot_index, _input, _id, _anim_name){
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
				var _offsets = JSON.load(working_directory + "sprites/" + global.availible_characters[global.character_index].image_folder + "/offset.json")
				
				var _offset = new Vec2(0,0);
				
				//log(find("animation").animation.__animation)
				for(var e = 0; e < array_length(_offsets); e++){
					if(_offsets[e].name == find("animation").animation.__animation)	{
						var _frame = clamp(find("animation").animation.__frame, 0, array_length(_offsets[e].offsets) - 1)
							_offset = new Vec2(_offsets[e].offsets[_frame].x, _offsets[e].offsets[_frame].y)
					}
				}
				
				
				//log(_offset)
				
				_x += _offset.x * _dir;
				_y += _offset.y;
				//log("added offsets")
			} else {
				//log(find("animation"))
			}
		}
			
		//create the projectile itself
		var _shot = noone
		
		
		var _tags = ["player"];
		
		//log(string(_tags) + " are the projectile tagts")
		
		_shot = PROJECTILES.create_projectile(_x, _y, _dir, _shot_data, self, _tags, self.damage_increase);
		
		self.projectile_count++;
		
		if variable_struct_exists(_shot.code, "stock_shot"){
			self.stock_shot = _shot.code.stock_shot
		}
		
		return _shot;
	}

	self.draw = function(){
		if(!global.debug) return;
		var _offsets = JSON.load(working_directory + "sprites/" + global.availible_characters[global.character_index].image_folder + "/offset.json")
				
		var _offset = new Vec2(0,0);
				
		//log(find("animation").animation.__animation)
				
		for(var e = 0; e < array_length(_offsets); e++){
			if(_offsets[e].name == find("animation").animation.__animation)	{
				_offset = new Vec2(_offsets[e].offsets[find("animation").animation.__frame].x, _offsets[e].offsets[find("animation").animation.__frame].y)
			}
		}
		
		_offset = new Vec2(get_instance().x + _offset.x * find("animation").animation.__xscale, get_instance().y + _offset.y)
		
		draw_sprite(spr_gamepad_reticle, 0, floor(get_instance().x), floor(get_instance().y))
		draw_sprite(spr_gamepad_reticle, 0, floor(_offset.x), floor(_offset.y))
	}
} 