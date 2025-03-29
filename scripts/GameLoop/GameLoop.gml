function GameLoop() : NET_GameLoopBase() constructor {
	self.step = function() {
		var _step = function(_component) { 
			if (!_component.step_enabled) return; 
			_component.step(); 
		};
		var _step_end = function(_component) { 
			if (!_component.step_enabled) return; 
			_component.step_end(); 
		};

		ENTITIES.for_each_component(EntityComponentPlayerInput, _step);
		ENTITIES.for_each_component(EntityComponentPlayerMove, _step);
		ENTITIES.for_each_component(EntityComponentAnimation, _step);
	}
	self.draw_gui = function() {
		draw_text(64, 96, $"frame: {parent.__current_frame}");
		draw_text(64, 128, $"input delay: {parent.__input_delay}");
	}
}