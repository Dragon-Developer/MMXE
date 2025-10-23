if (failed_binding) {
    var t = failed_binding_t++;
    if (input_check_pressed_any() && t > 1) {
        failed_binding = false;
        current_verb_index--;
        waitNewKey();
    }
}