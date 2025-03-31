function CombinationGenerator() constructor {
	static __combine = function(_arrays, _index, _current, _result) {
	    if (_index == array_length(_arrays)) {
	        array_push(_result, variable_clone(_current));
	        return;
	    }
	    var _current_array = _arrays[_index];
	    for (var _i = 0; _i < array_length(_current_array); _i++) {
	        var _next = variable_clone(_current);
	        array_push(_next, _current_array[_i]);
	        __combine(_arrays, _index + 1, _next, _result);
	    }
	}
	
	static generate_as_arrays = function(_arrays) {
	    var _raw_combinations = [];
	    __combine(_arrays, 0, [], _raw_combinations);
	    return array_filter(_raw_combinations, function(_val) { return _val != ""; }); ;
	}
	
	static generate_with_fallback = function(_arrays, _separator) {
	    var _result = [];
	    __combine(_arrays, 0, [], _result);
		var _combinations = [];
	    array_foreach(_result, method({ combinations: _combinations, separator: _separator}, function(_parts) {
			var _filtered_parts = array_filter(_parts, function(_val) { return _val != ""; }); 
			var _type = string_join_ext(separator, _filtered_parts);
			var _fallbacks = [];
	        var _current_fallback = "";
        
			for (var _i = 1, _len = array_length(_filtered_parts); _i < _len; _i++) {
				var _new_array = [];
				array_copy(_new_array, 0, _filtered_parts, _i, array_length(_filtered_parts))
		        _current_fallback = string_join_ext(separator, _new_array);
		        array_push(_fallbacks, _current_fallback);
			}
			//show_debug_message(_type);
			//show_debug_message(_fallbacks);
			array_push(combinations, {
				type: _type,
				fallbacks: _fallbacks
			});
	    }));

	    return _combinations;
	}
}
CombinationGenerator();