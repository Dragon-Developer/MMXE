// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GaeaBuster() : ProjectileWeapon() constructor{
	self.data = [GaeaBusterUnchargedData,GaeaBusterChargedData,GaeaBusterChargedData,GaeaBusterChargedData,HermesBuster5Data];
	self.charge_limit = 5;
	self.cost = 0;
	self.title = "X BUSTER";
	self.description = "Mega Buster Mark 17"
	
	self.weapon_palette = global.player_character[global.local_player_index].default_palette;
}

function GaeaBusterUnchargedData() : xBuster11Data() constructor{
	self.animation = "gaea_shot";
	self.damage = 2;
	self.comboiness = 5;
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

function GaeaBusterChargedData() : xBuster13Data() constructor{
	self.animation = "gaea_shot_charged";
	self.damage = 4;
	self.comboiness = -1;
}