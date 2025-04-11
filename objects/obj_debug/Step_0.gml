return;
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("D"))) {
	show_debug_log(debug);
	debug = !debug;
}