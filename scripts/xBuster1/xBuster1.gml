function xBuster() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster13Data,xBuster14Data,xBuster14Data];
	self.charge_limit = 2;
}

function xBuster11Data() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	self.create = function(_inst){
		//log(init_time)
		//may make this default
		_inst.components.publish("animation_play", { name: "xShot1" });
		_inst.mask_index = spr_lemon_mask;
		WORLD.play_sound("shoot_1");
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else _hspd = 6.25;
		if(!is_undefined(_inst))
			_inst.x += _hspd * self.dir;
	}
}

function xBuster12Data() : ProjectileData() constructor{
	self.comboiness = 1;//same combo damage as lemons, so it could be a good combo ender?
	self.damage = 2;
	self.create = function(_inst){
		_inst.components.publish("animation_play", { name: "xShot2" });
		WORLD.play_sound("shoot_2");
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		//first 10 frames the shot sticks to the player. how do? pass the player!
		if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 6;
		else _hspd = 6.25;
		_inst.x += _hspd * self.dir;
	}
}

function xBuster13Data() : ProjectileData() constructor{
	self.comboiness = 2;
	self.damage = 3;
	self.create = function(_inst){
		_inst.components.publish("animation_play", { name: "xShot3X1" });
		WORLD.play_sound("shoot_3");
	}
	self.step = function(_inst){
		var _hspd = 0;
		if (CURRENT_FRAME == self.init_time + 5) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 6;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 6.5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 7;
		else _hspd = 7.5;
		_inst.x += _hspd * self.dir;
	}
}

function xBuster14Data() : ProjectileData() constructor{
	self.comboiness = 15;//all the drill bits should connect
	self.damage = 32;
	self.create = function(_inst){
		_inst.components.publish("animation_play", { name: "xShot3X2" });
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else _hspd = 6.25;
		_inst.x += _hspd * self.dir;
	}
}


/*
if (dash) {
	if (global.dash_lemon_visible)
		sprite_index = spr_x_shot_11;
	else sprite_index = spr_x_shot_1;
	if (ds_exists(boss_damage, ds_type_map))
		boss_damage[? noone] = 2;
	atk = 2;
}

if (destroy)
{
	var t = destroy_t - 1;
	if (blocked_reflect && blocked && (t <= 1))
	{
		x = xprevious;
		y = yprevious;
		h_speed = -6 * dir;
		v_speed = -3;
		if (dash)
		{
			grav = 0.25;
		}
	}
}
*/