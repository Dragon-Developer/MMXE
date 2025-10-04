function GameLoop() : NET_GameLoopBase() constructor {
	self.game_speed = 1;
	self.game_timer = 0;
	self.debug = global.debug;// i aint gonna replace every instance when i can just do this
	
	self.blur = false;
	
	//thanks gacel ur the best
	// Always 255 on modern PCs;
	self.fullSpace = 255;
	// Here we use 31 as it's 15-bit max value.
	self.colorSpace = 31;
	
	self.save_state = function() {
		ENTITIES.save();	
	}
	self.load_state = function() {
		ENTITIES.load();	
	}
	self.print = function(_ext = "") {
		var _players = ENTITIES.find_all(["player"]);
		self.__log = "";
		array_foreach(_players, function(_player) {
			var _index = _player.components.get(ComponentPlayerInput).__player_index;
			
			self.__log += json_stringify({ x: _player.x, y: _player.y, index: _index });
		});
		LOG.print("[GAME STATE]: " + self.__log + _ext);	
	}
	self.entities_step = function() {
		var _step = function(_component) { 
			try{
				if(is_undefined(_component)) return;
				if(!is_struct(_component)) return;
				if (!_component.step_enabled) return; 
				_component.current_step_time += _component.timescale;
				if(_component.current_step_time >= 1){
					_component.step(); 
					_component.current_step_time -= 1;
				}
			} catch(_exception) {
				show_debug_message(_exception.message);
				show_debug_message(_exception.longMessage);
			    show_debug_message(_exception.script);
			    show_debug_message(_exception.stacktrace);
			}
		};
		
		ENTITIES.for_each_component(ComponentNode, _step);
		ENTITIES.for_each_component(ComponentPlayerInput, _step);
		ENTITIES.for_each_component(ComponentPlayerMove, _step);
		ENTITIES.for_each_component(ComponentPauseMenu, _step);
		ENTITIES.for_each_component(ComponentEnemy, _step);
		ENTITIES.for_each_component(ComponentBoss, _step);
		ENTITIES.for_each_component(ComponentWeaponUse, _step);
		ENTITIES.for_each_component(ComponentProjectile, _step);//may be deprecated
		ENTITIES.for_each_component(ComponentProjectileManager, _step);
		ENTITIES.for_each_component(ComponentGravityChanger, _step);
		ENTITIES.for_each_component(ComponentStageSelector, _step);
		ENTITIES.for_each_component(ComponentCharacterSelect, _step);
		ENTITIES.for_each_component(ComponentMask, _step);
		ENTITIES.for_each_component(ComponentPhysics, _step);
		ENTITIES.for_each_component(ComponentCharge, _step);
		ENTITIES.for_each_component(ComponentAnimation, _step);
		ENTITIES.for_each_component(ComponentAnimationShadered, _step);
		ENTITIES.for_each_component(ComponentSpriteRenderer, _step);
		ENTITIES.for_each_component(ComponentNPC, _step);
		ENTITIES.for_each_component(ComponentInteractibleContact, _step);
		ENTITIES.for_each_component(ComponentParallax, _step);
		ENTITIES.for_each_component(ComponentCamera, _step);
		ENTITIES.for_each_component(ComponentRide, _step);
		ENTITIES.for_each_component(ComponentDoor, _step);
		ENTITIES.for_each_component(ComponentDamageable, _step);
		ENTITIES.for_each_component(ComponentDialouge, _step);
		ENTITIES.for_each_component(ComponentHealthbar, _step);
		ENTITIES.for_each_component(ComponentParticles, _step);
		ENTITIES.for_each_component(ComponentCameraRecorder, _step);
		//Forte:
		//some way to have all components not defined here still run their step method
		//would make it easier to test
	}
	self.step = function() {
		try{
			self.game_timer += self.game_speed;
			while (self.game_timer >= 1) {
				self.game_timer -= 1;
				self.entities_step();
			}
		}catch(_exception) {
			show_debug_message(_exception.message);
			show_debug_message(_exception.longMessage);
			show_debug_message(_exception.script);
			show_debug_message(_exception.stacktrace);
			show_debug_message("this error was caught in the gameloop's step update. hopefully this helps!")
		}
	}
	
	self.draw_gui_begin = function(){
		//var _draw_gui = function(_component) { _component.draw_gui(); };
		//ENTITIES.for_each_component(ComponentDialouge, _draw_gui);
	}
	
	self.draw_gui = function() {
		var _draw_gui = function(_component) { _component.draw_gui(); };
		surface_set_target(application_surface)
		
		// some things use the draw_gui function regardless of debug
		ENTITIES.for_each_component(ComponentHealthbar, _draw_gui);
		ENTITIES.for_each_component(ComponentDialouge, _draw_gui);
		ENTITIES.for_each_component(ComponentMinimap, _draw_gui);
		ENTITIES.for_each_component(ComponentSpriteRenderer, _draw_gui);
		ENTITIES.for_each_component(ComponentEditorBar, _draw_gui);
		ENTITIES.for_each_component(ComponentInputDisplay, _draw_gui);
		ENTITIES.for_each_component(ComponentSoundLoader, _draw_gui);
		ENTITIES.for_each_component(ComponentBoss, _draw_gui);
		ENTITIES.for_each_component(ComponentPauseMenu, _draw_gui);
		ENTITIES.for_each_component(ComponentProjectileManager, _draw_gui);
		
		if(self.debug){
		
			ENTITIES.for_each_component(ComponentPlayerMove, _draw_gui);
			ENTITIES.for_each_component(ComponentCameraRecorder, _draw_gui);
		
			var _gui_width = display_get_gui_width();
			var _gui_height = display_get_gui_height();
		
			draw_set_valign(fa_top);
			draw_set_halign(fa_right);
			draw_set_color(c_white);
		
			draw_text(_gui_width - 16, 16, $"frame: {parent.__current_frame}");
			draw_text(_gui_width - 16, 32, $"delay: {parent.__input_delay}");
			draw_text(_gui_width - 16, 64, $"mode: {parent.__mode}");
			if (!is_undefined(global.socket)) {
				draw_text(_gui_width - 16, 48, $"ping: {global.socket.pingRpc.ping} ms");
			}
		}
		surface_reset_target();
		
		shader_set(shdr_snes_palette);
			var scale = floor(fullSpace / colorSpace);
			var deviation = floor(colorSpace / (fullSpace mod colorSpace));
			shader_set_uniform_f(shader_get_uniform(shdr_snes_palette, "scale"), scale);
			shader_set_uniform_f(shader_get_uniform(shdr_snes_palette, "deviation"), deviation);
			draw_surface(application_surface, 0, 0)
		shader_reset();
		
		if(keyboard_check_pressed(ord("5")))
			self.blur = !self.blur;
		
		if(self.blur){
			shader_set(shdr_forte_test);
			shader_set_uniform_f(shader_get_uniform(shdr_forte_test, "width"), GAME_W);
			shader_set_uniform_f(shader_get_uniform(shdr_forte_test, "height"), GAME_H);
			shader_set_uniform_f(shader_get_uniform(shdr_forte_test, "ScreenScale"), global.settings.Game_Scale);
			draw_surface(application_surface, 0, 0);
			shader_reset();
		}
	}
}
