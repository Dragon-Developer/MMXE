function EntityComponentInputBase() : EntityComponentBase() constructor {
	self.add_tags("input");
    self.get_input = function(_verb) { return 0; }
    self.get_input_pressed = function(_verb) { return 0; }
	self.set_swap_horizontal = function() {}
}
