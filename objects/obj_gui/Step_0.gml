try{
	if(room == rm_init)
	global.gui.step();
} catch(_err){
	log(_err)
}
var _generate_input = function(_inputs) {
	var _input = variable_clone(GAME.inputs.getEmptyInput());
	for (var _i = 0; _i < array_length(_inputs); _i++) {
		_input[$ _inputs[_i]] = true;
	}
	return _input;
}