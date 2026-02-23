function ComponentHealable() : ComponentBase() constructor{
	//deviating from my original plans a bit
	//im going to do all healing stuff in here
	//
	
	self.sub_tanks = []
	self.sub_tank_limit = 28;
	self.sub_tank_overflow = true;
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
			self.damageable = self.parent.get(ComponentDamageable);
		});
	}
	
	self.step = function(){
		self.detect_pickup();
	}
	
	self.detect_pickup = function(){
		var _inst = self.get_instance();
		var _pickup = self.physics.get_place_meeting(_inst.x, _inst.y, par_pickup)

		if(!instance_exists(_pickup) || _pickup == 0) return;
		
		var _data = _pickup.components.get(ComponentPickup).data;
		
		if(_data.skip_cond == "health_full" && get(ComponentDamageable).health == get(ComponentDamageable).health_max) return;
		if(_data.skip_cond == "weapon_full" && get(ComponentWeaponUse).weapon_ammo[get(ComponentWeaponUse).current_weapon[0]] == get(ComponentWeaponUse).weapon_max_ammo) return;
		
		var _pause = instance_create_depth(0,0,0,obj_give_pickup_after_pause);
		_pause.func = _data.apply;
		_pause.func_repeat = _data.count;
		_pause.collect_sound = _data.sound;
		_pause.music_wait = _data.delay;
		_pause.damageable = get(ComponentDamageable);
		with(obj_entity){
		if(variable_struct_exists(components, "__components"))
			array_foreach(components.__components, function(_comp){
				_comp.step_enabled = false;
			})
		}
		
		ENTITIES.destroy_instance(_pickup);
		instance_destroy(_pickup);
	}
	
	self.heal = function(_count, _pause){
		if(self.damageable.health + _count > self.damageable.health_max){
			self.add_to_sub_tank((self.damageable.health + _count - self.damageable.health_max));
		}
		self.get(ComponentDamageable).heal(_count)
	}
	
	self.add_max_health = function(_health){
		global.player_data.max_health += _health
		self.get(ComponentDamageable).health_max += _health;
		self.get(ComponentDamageable).heal(_health)
	}
	
	self.add_to_sub_tank = function(_count){
		array_foreach(self.sub_tanks, function(_tank, _count = _count){
			if(_tank < self.sub_tank_limit){
				while(_count > 0 && _tank < 28){
					_count--;
					_tank++;
				}
				
				if(_count <= 0)
					return;
			}
		})
	}
}