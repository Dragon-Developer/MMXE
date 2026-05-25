// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function struct_instantiate(_reference){
	var _struct = {};
	with(_struct){
		script_execute(_reference)
	}
	return _struct;
}