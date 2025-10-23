function Rebind(_verb){
	self.verb = _verb
	input_binding_scan_start(function(_binding) {
	    // Check collisions with this new binding
	    var _collisions = input_binding_test_collisions(verb, _binding);
	    // If it has no collision or it is the same verb
	    if (array_length(_collisions) == 0 || _collisions[0].verb == verb) {
	        // Set this new binding and wait new key
	        input_binding_set_safe(verb, _binding);
			return string(_binding)
	    } else if(array_length(_collisions) >= 1){
			var _old_bind = input_binding_get(verb)
			
			input_binding_set(_collisions[0].verb, _old_bind);
			
			input_binding_set_safe(verb, _binding);
			return string(_binding)
		}
	}, function() {
	    show_debug_message("failed");
	});
	return "nothing"
}