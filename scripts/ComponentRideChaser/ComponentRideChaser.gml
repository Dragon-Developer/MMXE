// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ComponentRideChaser() : ComponentPlayerMove() constructor{
	// Finite State Machine initialization
	self.add_base_state_machine = function(){
		
	self.reset_state_variables();
	self.fsm = new SnowState("init", true);
	self.fsm
		.history_enable()
		.history_set_max_size(10)
		.add("init", {
			enter: function() {
				self.publish("animation_play", { name: "idle" });
				
				
			}
		})
		.add("teleport_in", {
			enter: function() {
				self.publish("animation_play", { name: "tp_in" , reset: false});
				WORLD.play_sound("tp in");
				self.physics.set_speed(0, 0);
				self.physics.set_grav(new Vec2(0,0));
				self.physics.does_collisions = false;
				self.timer = (GAME_H / self.states.intro.speed) + CURRENT_FRAME + 1
			},
			step: function(){
				self.get_instance().y += self.states.intro.speed;
				
			},
			leave: function(){
				self.physics.set_speed(0, 0);
				self.physics.set_grav(self.physics.grav_default);
				self.physics.does_collisions = true;
				
				with(obj_camera){
					components.publish("target_set", other.get_instance());	
				}
			}
		})
		.add("intro", {
			enter: function() {
				var _frame = self.find("animation").animation.get_props(self.states.intro.animation).keyframes[0].frame;
				self.publish("animation_play", { name: self.states.intro.animation, frame: _frame, reset: false});
			}
		})
		.add("intro_end", {
			enter: function() {
				
				var _frame = self.find("animation").animation.get_props(self.states.intro.animation + "_end").keyframes[0].frame;
				self.publish("animation_play", { name: self.states.intro.animation + "_end", frame: _frame, reset: false});
			}
		})
		.add("idle", {
			enter: function() {
				if(get(ComponentDamageable).health < get(ComponentDamageable).health_max / 3)
					self.publish("animation_play", { name: "critical", reset: false, frame: 0 });
				else
					self.publish("animation_play", { name: "idle", reset: false, frame: 0 });
				self.physics.set_speed(0, 0);
				self.get_instance().y = ceil(self.get_instance().y)
				self.set_hor_movement(self.hdir);	
			},draw: function(){
			}
		})
		.add("turn", {
			enter: function() {
				//self.publish("animation_play", { name: "walk" });
				self.publish("animation_play", { name: self.states.walk.animation });
				self.current_hspd = self.states.walk.speed;
			},
			step: function() {
				self.set_hor_movement(self.hdir);	
			}
		})
		.add_transition("t_init", "init", "teleport_in")
		.add_transition("t_move_h", "idle", "walk", function() { return !self.physics.check_wall(self.hdir); })
		.add_transition("t_move_h", "land", "walk", function() { return !self.physics.check_wall(self.hdir) && !self.input.get_input("dash"); })
		.add_wildcard_transition("t_hurt", "hurt", function() { return self.get_wall_jump_dir() == 0; })
		.add_transition("t_jump", ["idle", "walk", "dash", "land", "dash_end", "crouch"], "jump", function() { return self.can_jump_check(); })
		.add_transition("t_jump", ["jump", "fall"], "jump", function() { return self.input.get_input_pressed_raw("jump") && double_jumps > 0; })
		.add_transition("t_crouch", "idle", "crouch")
		.add_wildcard_transition("t_custom", "custom")
		.add_transition("t_custom_end", "custom", "idle")
		.add_transition("t_custom_exit", "custom", "jump")
		.add_transition("t_animation_end", ["start", "land", "dash_end","ladder_exit", "hurt"], "idle")
		.add_transition("t_animation_end", "intro", "intro_end")
		.add_transition("t_animation_end", "intro_end", "idle")
		.add_transition("t_animation_end", "complete", "outro")
		.add_transition("t_animation_end", "pose", "idle")
		.add_transition("t_animation_end", "outro", "leave")
		.add_transition("t_animation_end", "ladder_enter", "ladder_move")
		.add_transition("t_jump", ["ladder_idle", "ladder_move", "ladder_enter"], "jump")
		.add_wildcard_transition("t_dialouge", "idle")
		.add_transition("t_hadouken", "idle", "land")
		/*automatic transitions between states*/
		.add_transition("t_transition", "teleport_in", "intro", function() {return self.timer <= CURRENT_FRAME })
		.add_transition("t_transition", "walk", "idle", function() { return self.hdir == 0 || self.physics.check_wall(self.hdir); })
		.add_transition("t_transition", "crouch", "idle", function() { return !self.input.get_input("down"); })
		.add_transition("t_transition", "jump", "fall", function() { return !self.input.get_input("jump") || self.physics.is_on_ceil() || self.physics.get_vspd() >= 0; })
		.add_transition("t_transition", ["fall", "idle", "walk", "dash", "walljump"], "ladder_enter", function() { return self.vdir != 0 && self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_ladder) && !(self.physics.is_on_floor(4) && self.vdir > 0)})
		.add_transition("t_transition", "ladder_idle", "ladder_move", function() { return self.vdir != 0})
		.add_transition("t_transition", "ladder_move", "ladder_idle", function() { return self.vdir == 0})
		.add_transition("t_transition", ["ladder_idle", "ladder_move"], "ladder_exit", function() { 
			return !self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y - 8, obj_ladder) || self.physics.is_on_floor(4)
		})
		.add_transition("t_transition", ["fall", "wall_slide", "wall_jump"], "land", function() { return self.physics.is_on_floor(self.ground_distance); })
		.add_transition("t_transition", ["idle", "walk", "crouch", "land"], "fall", function() { return !self.physics.is_on_floor(self.ground_distance); })
		.add_wildcard_transition("t_complete", "complete")
	}
	
}