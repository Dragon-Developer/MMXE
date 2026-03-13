function ComponentDoubleGearHandler() : ComponentBase() constructor{
	self.rate = 1;
	self.weapon_energy = 300;
	self.weapon_energy_max = 300;
	self.double_gear_percentage = 0.25;
	self.gear = "none";
	self.double_gear_time = -1;
	self.active = false;
	self.tired = false;
	self.logarithmic = false;
	self.x = 12;
	self.y = 96;
	
	self.init = function(){
		var _inst = self.get_instance();
		
		_inst.x = x;
		_inst.y = y;
	}
	
	self.step = function(){
		if(active){
			
			var _change = (self.rate);
			
			if logarithmic _change /= logn(2, weapon_energy + 2)
			
			if gear == "double" _change /= 0.75
			
			weapon_energy = clamp(weapon_energy - _change / global.game.game_loop.game_speed, 0, weapon_energy_max)
			
			if(weapon_energy <= 0){
				active = false;
				tired = true;
			}
		} else {
			var _change = (self.rate) / 2;
			
			if(tired) _change /= 1.5;
			
			
			
			weapon_energy = clamp(weapon_energy + _change, 0, weapon_energy_max)
			if(weapon_energy == weapon_energy_max && tired){
				tired = false;
				publish("animation_play", { name: "resting" });
				var _camera = instance_nearest(0,0,obj_camera)
				WORLD.spawn_particle(new PowerGearParticle(_camera.x + x, _camera.y + y, 1))
				WORLD.spawn_particle(new SpeedGearParticle(_camera.x + x, _camera.y + y, 1))
			}
		}
	}
	
	self.start_gear = function(_gear){
		gear = _gear;	
		publish("animation_play", { name:  string(_gear) + "_gearing" });
		active = true;
		
		if(double_gear_time != -1 && double_gear_time < CURRENT_FRAME)
			double_gear_time = CURRENT_FRAME + 5;
		else
			gear = "double"
	}
	
	self.stop_gear = function(_gear){
		if(gear != _gear) return;
			
		gear = "none";
				
		if !tired 
			publish("animation_play", { name: "resting" });
		else
			publish("animation_play", { name: "overheat" });
			
		active = false;
	}
	
	self.draw_gui_early = function(){
		
	}
	
	self.draw_gui = function(){
		
		
		if tired
			draw_set_color(c_red)
		else if active
			draw_set_color(#aaaaaa)
		else
			draw_set_color(#555555)
		draw_rectangle(x + 1,y + 33, x + 20 - (weapon_energy / weapon_energy_max) * 20,y + 36, false)
	}
}