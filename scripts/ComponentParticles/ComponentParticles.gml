function ComponentParticles() : ComponentBase() constructor{
	//essentially, it takes an array of particles with structs for movement data and such,
	// and renders them ALL
	
	self.particles = [];//this one will get its data added and removed. 
	
	self.step = function(){
		try {
		self.process_particles();
		} catch(_exception) {
			show_debug_message(_exception.message);
			show_debug_message(_exception.longMessage);
			show_debug_message(_exception.script);
			show_debug_message(_exception.stacktrace);
		}
	}
	
	self.process_particles = function(){
		self.clean_particles();
		array_foreach(particles,function(_particle){
			//if(exists)
			if (is_struct(_particle)) {
				//_particle.position.add(_particle.velocity);
				switch(_particle.death_mode){
					case "duration_lifetime":
						_particle.time++;
						_particle.frame = (_particle.time / _particle.time_max) *  array_length(sprite_get_info(_particle.sprite).frames)
						if(_particle.time > _particle.time_max){
							//array_delete(self.particles, array_get_index(particles, _particle),1)
							_particle.dead = true;
						}
					break;
					case "duration_frame":
						_particle.time++;
						if(_particle.time >= _particle.time_max && 
						_particle.frame > array_length(sprite_get_info(_particle.sprite).frames) - 3){
							_particle.dead = true;
							//array_delete(self.particles, array_get_index(particles, _particle),1)
						}
						if(_particle.time >= _particle.time_max){
							_particle.frame++;
							_particle.time = 0;
						}
					break;
				}
			}
		});
		//self.clean_particles();
	}
	
	self.draw = function(){
		array_foreach(particles,function(_particle){
			if (is_struct(_particle)) {
				if(is_string(_particle.sprite))
					_particle.sprite = real(_particle.sprite);
				else
					draw_sprite_ext(_particle.sprite, _particle.frame, _particle.position.x, _particle.position.y, _particle.dir, _particle.vdir, 0, c_white, 1);
			}
		});
	}
	
	self.clean_particles = function(){
		var _new_particles = [];
		//log(particles)
		for(var g = 0; g < array_length(self.particles); g++){
			if(!self.particles[g].dead && self.particles[g] != 0.00)
				array_push(_new_particles, self.particles[g])
		}
		self.particles = _new_particles;
	}
	
	self.add_particle = function(_particle, _x, _y){
		//_particle.position = new Vec2(_x, _y);
		array_push(particles, _particle);
	}
}


/*

on the user side, it should be as simple as "pass in a particle struct and move on"
this involves making a particle struct. i dont feel too bad lumping that in here, because this 
script handles particles. 

*/

function ParticleBase() constructor{
	self.sprite = spr_player_dash_spark;
	self.death_mode = "animation_end";
	self.velocity = new Vec2(0,0);
	self.position = new Vec2(0,0);
	self.time = 0;
	self.time_max = 3;
	self.frame = 0;
	self.dead = false;
	self.dir = 1;
	self.vdir = 1;
}