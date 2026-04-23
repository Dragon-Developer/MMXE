function ShadowBuster() : ProjectileWeapon() constructor{
	self.data = [xBusterShadow1Data,xBusterShadow2Data,ShadowSaber,xBuster24_1Data,xBuster25_1Data];
	self.charge_limit = 2;
	self.cost = 0;
	self.title = "X BUSTER";
	self.description = "Upgraded Mega Buster"
}

function xBusterShadow1Data() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 5;
	self.animation = "shadow_shot";
	self.yspd = random_range(-2,2)
	
	self.create = function(_inst){
		//log(init_time)
		//may make this default
		WORLD.play_sound("shoot_1");
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else if (CURRENT_FRAME - self.init_time > 24)_hspd = 6.25;
		if(!is_undefined(_inst))
			_inst.x += _hspd * self.dir;
			_inst.y += yspd;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function xBusterShadowRoofData() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 0;//one full volley of lemons
	
	self.shot_limit = 5;
	self.animation = "shadow_shot";
	self.yspd = random_range(-2,2)
	
	self.create = function(_inst){
		//log(init_time)
		//may make this default
		WORLD.play_sound("shoot_1");
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		if (is_in_range(CURRENT_FRAME, self.init_time, self.init_time + 2)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 2, self.init_time + 5)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 24)) _hspd = 6;
		else if (CURRENT_FRAME - self.init_time > 24)_hspd = 6.25;
		if(!is_undefined(_inst))
			_inst.y += _hspd * self.dir;
			_inst.x += yspd;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function xBusterShadow2Data() : ProjectileData() constructor{
	self.comboiness = 1;//same combo damage as lemons, so it could be a good combo ender?
	self.damage = 2;
	self.shot_limit = 4;
	self.yspd = random_range(-2,2)
	
	self.hitbox_scale = new Vec2(16,16);
	self.hitbox_offset = new Vec2(16,0);
	self.animation = "shadow_half_charge";

	self.create = function(_inst){
		//_inst.components.publish("animation_play", { name: "xShot2" });
		WORLD.play_sound("shoot_2");
	}
	self.step = function(_inst){
		
		var _hspd = 0;
		//first 10 frames the shot sticks to the player. how do? pass the player!
		if (is_in_range(CURRENT_FRAME, self.init_time + 5, self.init_time + 8)) _hspd = 4;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 8, self.init_time + 10)) _hspd = 5;
		else if (is_in_range(CURRENT_FRAME, self.init_time + 10, self.init_time + 12)) _hspd = 6;
		else if (CURRENT_FRAME - self.init_time > 12)_hspd = 6.25;
		_inst.x += _hspd * self.dir;
			_inst.y += yspd;
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LimeDieParticle(_inst.x + 16 * dir, _inst.y, self.dir))
	}
}

function ShadowSaber() : MeleeData() constructor{
	
	//theres a thousand and one ways to handle this
	//i dont think i did it in the best way possible
	//notably moves that also change the player's position would also have to be state based
	//but you dont switch weapons to get to them so do i add them as special weapons and add the checks here?
	self.create = function(_inst){
		WORLD.play_sound("saber_swing");
	}
	
	self.set_player_state = function(_plr, _charge){
		var _current_swing = _plr.states.melee.animation;
		
		if(_current_swing == "atk_1_x" || _current_swing == "atk_jump_x"){
			return;//bail!
		} else if(!_plr.physics.is_on_floor()){
			set_player_melee_info(_plr, "atk_jump_x", 0, new Vec2(24,-8), new Vec2(64,56), 4)
		} else {
			set_player_melee_info(_plr, "atk_1_x", 1, new Vec2(32,-8), new Vec2(40,48), 5)
		}
		
		_plr.fsm.change("melee");
	}
}