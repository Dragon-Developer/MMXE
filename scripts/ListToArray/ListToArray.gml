function instance_place_array(_x, _y, _obj, _ordered) {
	static __list = ds_list_create();
	var _size = instance_place_list(_x, _y, _obj, __list, _ordered);
	var _array = array_create(_size, 0);
	for (var _i = 0; _i < _size; _i++) {
		_array[_i] = __list[| _i];
	}
	ds_list_clear(__list);
	return _array;
}