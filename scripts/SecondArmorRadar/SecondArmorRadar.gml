// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function SecondArmorRadar() : ProjectileWeapon() constructor{
	self.data = [RadarData];
	self.charge_limit = 0;
	self.animation_append = "";
	self.weapon_palette = [
		#2030ff,//Blue Armor Bits
		#0040ff,
		#0080ff,
		#1858b0,//Under Armor Teal Bits
		#50a0f0,
		#78d8f0,
		#383838,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#ff4f1f//red
	];
}

function RadarData() : ProjectileData() constructor{
	
	self.nearest_instance = noone;
	self.goal_instance = obj_npc;
	self.tracking_delay = CURRENT_FRAME + 28;
	self.track_rate = 3;
	
	self.create = function(_inst){
		with(par_projectile){
			if(components.get(ComponentProjectile).weaponCreate != other && components.get(ComponentProjectile).weaponData == RadarData){
				x = -1000;
				y = -1000;
			}
		}
		_inst.components.publish("animation_play", { name: "radar" });
	}
	
	self.step = function(_inst){
		if(self.tracking_delay > CURRENT_FRAME){
			_inst.x += self.dir * self.track_rate;
			return;
		}
			
		if(self.nearest_instance == noone){
			self.nearest_instance = instance_nearest(_inst.x, _inst.y, self.goal_instance);
		} else {
			//i had that gut feeling these needed to be reversed
			_inst.x -= clamp(_inst.x - self.nearest_instance.x, -1,1) * self.track_rate
			_inst.y -= clamp(_inst.y - self.nearest_instance.y, -1,1) * self.track_rate
			
			if abs(_inst.x - self.nearest_instance.x) < self.track_rate * 2
				_inst.x = self.nearest_instance.x;
			if abs(_inst.y - self.nearest_instance.y) < self.track_rate * 2
				_inst.y = self.nearest_instance.y;
				
			_inst.x = floor(_inst.x);
			_inst.y = floor(_inst.y);
		}
	}
}