function LittleShit() : BaseEnemy() constructor{
	self.health = 3;
	
	self.sprite = "little_shit"
	
	self.fire_time = CURRENT_FRAME + 230;
	self.close_enough_to_player = false;
	
	self.step = function(_self){
		var _plr = instance_nearest(0,0,obj_player)
		var _dist = (_plr.x - _self.x) + (_plr.y - _self.y);
		
		if(abs(_dist) < 120){
			if(!close_enough_to_player){
				fire_time = CURRENT_FRAME + 120;
				//log("IMMA FIRIN DA LAZER")
				//log(distance_to_object(_plr))
			}
			close_enough_to_player = true;
		} else {
			close_enough_to_player = false;
				//log(distance_to_object(_plr))
		}
		
		if(close_enough_to_player && fire_time < CURRENT_FRAME + 20){
			sprite = "little_shit_throw"
		}
		
		if(close_enough_to_player && fire_time < CURRENT_FRAME){
			var _pick = PROJECTILES.create_projectile(_self.x, _self.y, 1, AnnoyingPickaxe, undefined, ["enemy"]);
			
			var g = 0.25; // Gravity
			var d = instance_nearest(0,0,obj_player).x - _self.x; // Hor Distance
			var h1 = max(0,96 - abs(d) / 8); // Max height relative to the pickaxe
			var h2 = max(0, h1 + instance_nearest(0,0,obj_player).y - _self.y); // Max height relative to the player
			
			//log(h1)
			//log(h2)
			
			_pick.code.hspd = d * sqrt(g) / (sqrt(2) * (sqrt(h1) + sqrt(h2)));
			_pick.code.vspd = -sqrt(2 * g * h1);
			_pick.code.dir = (d == abs(d) ? 1 : -1);
			dir = _pick.code.dir;
			
			fire_time += 200;
		}
		
		if(close_enough_to_player && fire_time < CURRENT_FRAME - 20){
			sprite = "little_shit"
		}
	}
}

function AnnoyingPickaxe() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 1;//one full volley of lemons
	
	self.shot_limit = 2;
	self.damage = 2;
	self.animation = "fuckass_pickaxe";
	self.vspd = 0;
	self.hspd = 0;
	
	self.create = function(_inst){}
	self.step = function(_inst){
		_inst.x += hspd;
		_inst.y += vspd;
		vspd += 0.25;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}