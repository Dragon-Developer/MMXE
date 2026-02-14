function Rebind(_verb){
	self.verb = _verb
	self.old_bind = input_binding_get(verb)
	
	input_binding_set(verb, input_binding_empty());
	
	input_binding_scan_start(function(_binding) {
	    // Check collisions with this new binding
	    var _collisions = input_binding_test_collisions(verb, _binding);
	    // If it has no collision or it is the same verb
	    if (array_length(_collisions) == 0) {
	        // Set this new binding and wait new key
	        input_binding_set_safe(verb, _binding);
			other.binding = string(_binding)
			
		} else if(_collisions[0].verb == verb || array_length(_collisions) >= 1){
			
			input_binding_set(_collisions[0].verb, old_bind);
			
			input_binding_set_safe(verb, _binding);
			other.binding = string(_binding)
		}
	}, function() {
	    show_debug_message("failed");
	});
}