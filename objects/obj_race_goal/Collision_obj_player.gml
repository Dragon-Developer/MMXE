var _fsm = other.components.get(ComponentPlayerMove).fsm;
if(!_fsm.state_exists("race_warp")){
	with(other.components.get(ComponentPlayerMove)){
		_fsm.add("race_warp", {
			enter: function() {
				self.physics.set_speed(0, 0);
				self.physics.set_grav(new Vec2(0,0));
				self.publish("animation_play", { name: self.states.dash.animation });
				
				if(get(ComponentPlayerInput).get_player_index() != global.local_player_index) return;
				
				with(obj_camera){
					components.get(ComponentCamera).movement_limit_x *= 1000;
					components.get(ComponentCamera).movement_limit_y *= 1000;
				}
				with(obj_race_handler){
					laps_left--;
					timer_paused = true;
					
					if(laps_left <= -1){
						if(!is_undefined(global.server))
							global.server.upload_time(final_time);
						else
							global.client.upload_time(final_time, global.local_player_index);
					}
				}
			},
			step: function() {
				with(self.get_instance()){
					var _return_point = instance_nearest(0,0,obj_race_start_point)
					move_towards_point(_return_point.x, _return_point.y,45);
				}
			},
			leave: function(){
				self.physics.update_gravity();
				self.physics.set_speed(0,0);
				var _return_point = instance_nearest(0,0,obj_race_start_point)
				
				self.get_instance().x = _return_point.x;
				self.get_instance().y = _return_point.y;
				self.get_instance().speed = 0;
				
				if(get(ComponentPlayerInput).get_player_index() != global.local_player_index) return;
				
				with(obj_camera){
					components.get(ComponentCamera).movement_limit_x /= 1000;
					components.get(ComponentCamera).movement_limit_y /= 1000;
				}
				with(obj_race_handler){
					timer_paused = false;
				}
			}
		})
		.add_transition("t_transition", "race_warp", "fall", function(){
			return self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_race_start_point)
		})
	}
}

_fsm.change("race_warp");