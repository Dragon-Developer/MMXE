current_verb_index = -1;
current_verb = "";
failed_binding = false;
failed_binding_t = 0;
backup_binding = [];
verb = [];
for (var i = 0; i < array_length(global.verbs); i++) {
    verb[i] = global.verbs[i];
    array_push(backup_binding, input_binding_get(verb[i]));    
}
/// @function    resetBinding()
resetBinding = function() {
    failed_binding_t = 0;
    failed_binding = true;
    /*
    for (var i = 0; i < array_length(verb); i++) {
        input_binding_set(verb[i], backup_binding[i]);
    }*/
}
/// @function    waitNewKey()
waitNewKey = function() {
    // Update next key
    current_verb_index++;
    // If reached last key, go back to control menu
    if (current_verb_index >= array_length(verb)) {
        room_goto(r_control_menu);
        input_save();
        return;
    }
    // Get current verb
    current_verb = verb[current_verb_index];
    // Scan for new key
    input_binding_scan_start(function(_binding) {
        // Check collisions with this new binding
        var _collisions = input_binding_test_collisions(current_verb, _binding);
        // If it has no collision or it is the same verb
        if (array_length(_collisions) == 0 || _collisions[0].verb == current_verb) {
            // Set this new binding and wait new key
            input_binding_set_safe(current_verb, _binding);
            waitNewKey();
        } else {
            // Otherwise, reset binding and show warning
            resetBinding();    
        }
    }, function() {
        // Failed
        current_verb_index--;
        waitNewKey();
        show_debug_message("failed");
    });
}