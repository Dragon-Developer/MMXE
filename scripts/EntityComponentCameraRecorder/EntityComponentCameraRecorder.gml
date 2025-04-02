function EntityComponentCameraRecorder() : EntityComponentBase() constructor {
	self.current_frame = 0;
	self.recording = false;
	self.folder = "/frame-record/";
	self.get_frame_name = function(_index) {
//		var _frame = string_replace_all(string_format(string(_index), 8, 0), " ", "0");
		var _frame = _index;
		return $"{self.folder}frame_{_frame}.png"; 
	}
	self.save_frame = function() {
		var _fname = self.get_frame_name(self.current_frame);
		self.current_frame++;
		surface_save(application_surface, _fname);
	}
	self.step = function() {
		if (keyboard_check_pressed(ord("4"))) {
			if (!self.recording) {
				self.start_recording();
			} else {
				self.finish_recording();	
			}
		}
	}
	self.start_recording = function() {
		self.current_frame = 0;
		self.recording = true;
	}
	self.finish_recording = function() {
		self.recording = false;
		self.current_frame = 0;
	}
	self.draw_gui = function() {
		if (!self.recording) return;
		draw_set_halign(fa_right);
		draw_set_valign(fa_top);
		draw_set_color(c_white);
		var _width = display_get_gui_width();
		draw_text(_width - 16, 80, "RECORDING: " + string(self.current_frame));
		self.save_frame();
	}
}