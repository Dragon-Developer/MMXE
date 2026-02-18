function PopDash() : ProjectileWeapon() constructor{
	self.data = [PopDashProjectile,PopDashProjectile,PopDashProjectile,SuperPopDashProjectile,SuperPopDashProjectile];
	self.charge_limit = 0;
	self.cost = 0.25
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

function PopDashProjectile() : StateBasedData() constructor{
	self.state_name = "Pop Dash"
	
	self.init = function(_player){
		with(_player){
			fsm.add(other.state_name,{
				enter: function() {//
					WORLD.play_sound("dash");
					var _inst = self.get_instance()
					WORLD.spawn_particle(new DashParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
					self.timer = CURRENT_FRAME + self.states.dash.interval / 4;
					self.current_hspd = self.states.dash.speed * 2.5;	
					self.dash_dir = self.dir;
					if(self.dash_dir == 0)
						self.dash_dir = self.hdir;
					self.publish("animation_play", { name: "dash" });
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

function SuperPopDashProjectile() : StateBasedData() constructor{
	self.state_name = "Super Pop Dash"
	
	self.init = function(_player){
		with(_player){
			fsm.add(other.state_name,{
				enter: function() {//
					WORLD.play_sound("dash");
					var _inst = self.get_instance()
					WORLD.spawn_particle(new DashParticle(_inst.x- 16 * self.dir, _inst.y + 16, self.dir))
					self.timer = CURRENT_FRAME + self.states.dash.interval / 2;
					self.current_hspd = self.states.dash.speed * 3.5;	
					self.dash_dir = self.dir;
					if(self.dash_dir == 0)
						self.dash_dir = self.hdir;
					self.publish("animation_play", { name: "dash" });
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