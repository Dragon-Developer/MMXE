// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function SecondArmorRadar() : ProjectileWeapon() constructor{
	self.data = [RadarData];
	self.charge_limit = 0;
	self.weapon_palette = [
		#2030ff,//Blue Armor Bits
		#0040ff,
		#0080ff,
		#1858b0,//Under Armor Teal Bits
		#50a0f0,
		#78d8f0,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
}

function RadarData() : ProjectileData() constructor{
	
	self.nearest_instance = noone;
	self.goal_instance = obj_player;
	
	self.create = function(_inst){
		_inst.components.publish("animation_play", { name: "radar" });
	}
	
	self.step = function(_inst){
			
		if(self.nearest_instance == noone){
			self.nearest_instance = instance_nearest(_inst.x, _inst.y, self.goal_instance);
		} else {
			//i had that gut feeling these needed to be reversed
			_inst.x -= clamp(_inst.x - self.nearest_instance.x, -1,1)
			_inst.y -= clamp(_inst.y - self.nearest_instance.y, -1,1)
		}
	}
}