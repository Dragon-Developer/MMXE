function shotgunIce() : ProjectileWeapon() constructor{
	self.data = [SpeedBurnerFullCharge,xBuster12Data,xBuster13Data,xBuster14Data,xBuster14Data];
	self.charge_limit = 0;
	self.weapon_palette = [
		#3973f7,//Blue Armor Bits
		#529cef,
		#39e7ff,
		#ad6b21,//Under Armor Teal Bits
		#efad31,
		#ffe752,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	self.title = "S. ICE";
}

function SpeedBurnerFullCharge() : StateBasedData() constructor{
	self.state_name = "Speed Burner"
	
	self.init = function(_player){
		with(_player){
			fsm.add(other.state_name,{
				enter: function() {//
					WORLD.play_sound("dash");
					var _inst = self.get_instance()
					WORLD.spawn_particle(new DashParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
					self.timer = CURRENT_FRAME + self.states.dash.interval / 1.5;
					self.current_hspd = self.states.dash.speed * 1.5;	
					self.dash_dir = self.dir;
					if(self.dash_dir == 0)
						self.dash_dir = self.hdir;
					self.publish("animation_play", { name: "speed_burner" });
					self.physics.set_speed(0, 0);
					self.physics.set_grav(new Vec2(0,0));
				},
				step: function() {
					self.set_hor_movement(self.dash_dir);
				},
				leave: function() {
					//if (!self.dash_jump && self.physics.is_on_floor())
						//self.current_hspd = self.states.walk.speed;	
					self.physics.set_grav(new Vec2(0,0.25));
				}
			})
			.add_transition("t_dash_end", other.state_name, "fall", function() { return self.physics.is_on_floor(); })
			.add_transition("t_transition", other.state_name, "fall", function() 
				{ 
					var _facing_correct_direction = (self.hdir != self.dash_dir && (self.hdir != 0 || self.dash_tapped))
					var _timer_up = self.timer <= CURRENT_FRAME;
					return _facing_correct_direction || _timer_up; })
		}
	}
}

function boomerangCutter() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster13Data,xBuster14Data,xBuster14Data];
	self.charge_limit = 0;
	self.weapon_palette = [
		#424252,//Blue Armor Bits
		#636384,
		#737394,
		#84ad8c,//Under Armor Teal Bits
		#a5c6ad,
		#ceefd6,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	self.title = "B. CUTTER";
}

function electricSpark() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster13Data,xBuster14Data,xBuster14Data];
	self.charge_limit = 0;
	self.weapon_palette = [
		#7b5200,//Blue Armor Bits
		#c67b08,
		#ffb508,
		#a5a5a5,//Under Armor Teal Bits
		#b5b5b5,
		#dedede,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	self.title = "E. SPARK";
}

function stormTornado() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster13Data,xBuster14Data,xBuster14Data];
	self.charge_limit = 0;
	self.weapon_palette = [
		#73317b,//Blue Armor Bits
		#9c5294,
		#9c5a94,
		#d684b5,//Under Armor Teal Bits
		#c794c6,
		#ffc6e7,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	self.title = "STORM T.";
}

function fireWave() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster13Data,xBuster14Data,xBuster14Data];
	self.charge_limit = 0;
	self.weapon_palette = [
		#a51800,//Blue Armor Bits
		#d63918,
		#f75208,
		#f76318,//Under Armor Teal Bits
		#ffa542,
		#ffe77b,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	self.title = "FIRE WAVE";
}

function rollingShield() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster13Data,xBuster14Data,xBuster14Data];
	self.charge_limit = 0;
	self.weapon_palette = [
		#d62142,//Blue Armor Bits
		#e74263,
		#f7849c,
		#84ad8c,//Under Armor Teal Bits
		#a5c6ad,
		#ceefd6,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	self.title = "R. SHIELD";
}

function chameleonSting() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster13Data,xBuster14Data,xBuster14Data];
	self.charge_limit = 0;
	self.weapon_palette = [
		#085229,//Blue Armor Bits
		#219452,
		#18b552,
		#21bd7b,//Under Armor Teal Bits
		#63d6ad,
		#c6f7e7,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	self.title = "C. STING";
}

function homingTorpedo() : ProjectileWeapon() constructor{
	self.data = [xBuster11Data,xBuster12Data,xBuster13Data,xBuster14Data,xBuster14Data];
	self.charge_limit = 0;
	self.weapon_palette = [
		#425a42,//Blue Armor Bits
		#6b7b6b,
		#849484,
		#bd946b,//Under Armor Teal Bits
		#deb58c,
		#ffdeb5,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
	self.title = "HOMING T.";
}