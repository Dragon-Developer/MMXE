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
		ENTITIES.for_each_component(EntityComponentMask, _step);
		ENTITIES.for_each_component(EntityComponentPhysics, _step);
		ENTITIES.for_each_component(EntityComponentAnimation, _step);
		ENTITIES.for_each_component(EntityComponentCameraGuide, _step);
		ENTITIES.for_each_component(EntityComponentCamera, _step);
		
	}
	self.draw_gui = function() {
		var _draw_gui = function(_component) { _component.draw_gui(); };
		
		ENTITIES.for_each_component(EntityComponentPlayerMove, _draw_gui);
		
		var _gui_width = display_get_gui_width();
		var _gui_height = display_get_gui_height();
		
		draw_set_valign(fa_top);
		draw_set_halign(fa_right);
		
		draw_text(_gui_width - 16, 16, $"frame: {parent.__current_frame}");
		draw_text(_gui_width - 16, 32, $"delay: {parent.__input_delay}");
	}
}