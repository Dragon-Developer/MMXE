global.gui.step();
var _generate_input = function(_inputs) {
	var _input = variable_clone(GAME.inputs.getEmptyInput());
	for (var _i = 0; _i < array_length(_inputs); _i++) {
		_input[$ _inputs[_i]] = true;
	}
	return _input;
}
if (keyboard_check_pressed(ord("Q"))) {
	GAME.step();
	GAME.add_input(0, 1, _generate_input([]));
	GAME.add_input(1, 1, _generate_input(["left"]));
	GAME.add_input(2, 1, _generate_input(["left"]));
	GAME.add_input(3, 1, _generate_input(["left"]));
	GAME.add_input(4, 1, _generate_input(["left"]));
	GAME.step();
	GAME.add_input(5, 1, _generate_input(["right"]));
	GAME.step();
}

if(transition_data.transitioning){
	
}