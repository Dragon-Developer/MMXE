function GameLoop() : NET_GameLoopBase() constructor {
	self.game_speed = 1;
	self.game_timer = 0;
	self.debug = true;//should make this a global variable
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
			var _index = _player.components.get(EntityComponentPlayerInput).__player_index;
			
			self.__log += json_stringify({ x: _player.x, y: _player.y, index: _index });
		});
		LOG.print("[GAME STATE]: " + self.__log + _ext);	
	}
	self.entities_step = function() {
		var _step = function(_component) { 
			if (!_component.step_enabled) return; 
			_component.step(); 
		};
		var _step_end = function(_component) { 
			if (!_component.step_enabled) return; 
			_component.step_end(); 
		};
		
		ENTITIES.for_each_component(ComponentPlayerInput, _step);
		ENTITIES.for_each_component(ComponentPlayerMove, _step);
		ENTITIES.for_each_component(ComponentMask, _step);
		ENTITIES.for_each_component(ComponentPhysics, _step);
		ENTITIES.for_each_component(ComponentAnimation, _step);
		ENTITIES.for_each_component(ComponentCamera, _step);
		ENTITIES.for_each_component(ComponentRide, _step);
		ENTITIES.for_each_component(ComponentEditorBar, _step);
		ENTITIES.for_each_component(ComponentCameraRecorder, _step);
	}
	self.step = function() {
		self.game_timer += self.game_speed;
		while (self.game_timer >= 1) {
			self.game_timer -= 1;
			self.entities_step();
		}
		
	}
	self.draw_gui = function() {
		var _draw_gui = function(_component) { _component.draw_gui(); };
		ENTITIES.for_each_component(ComponentEditorBar, _draw_gui);
		if(!self.debug) return;
		
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
}