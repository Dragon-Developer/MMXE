function batEnemy() : BaseEnemy() constructor{
    self.health = 1;
    self.stun_offset = 0;
	self.x = 0;
	self.y = 0;
    fly_speed = 1.25;
	self.init = function(){
		self.fsm.trigger("t_init");
	}
	self.step = function(_self){
		if (self.fsm.event_exists("step"))
		{
			self.fsm.step();
		}
		
	}
	
	self.fsm = new SnowState("init", false);
	
	self.fsm
		.history_enable()
		.history_set_max_size(10)
		.add("init", {})
		.add("idle", {
			enter: function() {
				
				
			},
			step: function(){
				with(EnemyComponent.get_instance()){
					if(distance_to_object(obj_player) < 128)
					{
						other.fsm.trigger("t_attack");
					}
				}
				
				if(self.EnemyComponent != noone && self.EnemyComponent != undefined && variable_struct_exists(self.EnemyComponent, "publish"))
				{
					self.EnemyComponent.publish("animation_play", { name: "batIdle" });
				}
			}
		})
		.add("attack", {
			enter: function() {
				self.EnemyComponent.publish("animation_play", { name: "batAttacking" });
				
			},
			step: function(){
				with(EnemyComponent.get_instance()){
					var player = instance_nearest(x, y, obj_player);
					move_towards_point(player.x, player.y, other.fly_speed);
				}
			}
		})
		.add("retreat", {
			enter: function() {
				self.EnemyComponent.publish("animation_play", { name: "batRetreating" });
				
			},
		})
		.add_transition("t_attack", "idle", "attack")
		.add_transition("t_init", "init", "idle")
		
		
}