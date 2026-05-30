function AresBuster() : ProjectileWeapon() constructor{
	self.data = [AresBuster1Data,AresBuster2Data,AresBuster3Data,AresBuster4Data];
	self.charge_limit = 4;
	self.cost = 0;
	self.title = "X BUSTER";
	self.description = "Mega Buster Mark 17"
	
	self.weapon_palette = [
		global.availible_characters[global.character_index].default_palette[0],
		global.availible_characters[global.character_index].default_palette[1],
		global.availible_characters[global.character_index].default_palette[2],
		global.availible_characters[global.character_index].default_palette[3],
		global.availible_characters[global.character_index].default_palette[4],
		global.availible_characters[global.character_index].default_palette[5]
	]
}

function AresBuster1Data() : xBuster11Data() constructor{
	self.animation = "hermes_shot_0";
	
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else _hspd = 6.5;
		if(!is_undefined(_inst))
			_inst.x += _hspd * self.dir;
	}
}

function AresBuster2Data() : xBuster12Data() constructor{
	self.animation = "hermes_shot_1";
	self.rot = new Vec2(0,0);
	atk = 2;
	destroy_if_equal_to_atk = true;
	abs_speed_max = 4;
	abs_speed = 1;
	acceleration = 0.2;
	target = noone;
	h_accel = 0;
	v_accel = 0;
	h_speed = 0;
	v_speed = 0;
	dir_angle = dir * 90 - 90;
	shot_type = 1;
	angle_max_change = 8.5;
	accel_type = 1;
	auto_rotate = false;
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_2");
		dir_angle = dir * 90 - 90;
	}
	
	self.step = function(_inst){
		
		var target = undefined
		
		try{
			target = ENEMIES.get_nearest_enemy(_inst.x, _inst.y)
		}catch(_err){
			//nothing lol
		}
		
		if target == undefined {
			target = instance_nearest(_inst.x, _inst.y, par_boss)
			if target > 0
				target.position = new Vec2(target.x, target.y)
		}
		
		if target < 0 target = {position: new Vec2(0,0)}
		
		accel_type = 1;
		if (target != noone) {
			auto_rotate = false;
			var t_angle = point_direction(_inst.x, _inst.y, target.position.x, target.position.y);
			var dd = clamp(angle_difference(t_angle, dir_angle), angle_max_change * -1, angle_max_change);
			var d = point_distance(_inst.x, _inst.y, target.position.x, target.position.y)
			if (d < 48 || abs(dd) < 75) {
				if (abs(dd) > 8) {
					dir_angle += dd / 4;
					abs_speed = max(0, abs_speed - abs(dd) / 180);
				}
			} else {
				accel_type = 0;
				h_speed += lengthdir_x(acceleration, t_angle);
				v_speed += lengthdir_y(acceleration, t_angle);
				dir_angle = point_direction(_inst.x, _inst.y, _inst.x + h_speed, _inst.y + v_speed);
				abs_speed = min(abs_speed_max, sqrt(max(0, h_speed * h_speed + v_speed * v_speed)));
			}

		}
		if (auto_rotate) {
			var dd = angle_difference(dir_angle, (dir == 1) ? 0 : 180);
			if (abs(dd) > 30) {
				dir_angle -= 2*sign(dd);	
			}
		}
		if (accel_type == 1)
			abs_speed = min(abs_speed_max, abs_speed + acceleration);
		h_speed = lengthdir_x(abs_speed, dir_angle);
		v_speed = lengthdir_y(abs_speed, dir_angle);
			
			
		
		_inst.x += h_speed;
		_inst.y += v_speed;
	}
	
	self.draw = function(_inst){
		
	}
}

function AresBuster3Data() : AresBuster2Data() constructor {
	self.angle_max_change *= 2;
}

function AresBuster4Data() : AresBuster2Data() constructor {
	self.angle_max_change *= 3;
}