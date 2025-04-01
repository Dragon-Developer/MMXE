function array_median(_arr) {
    if (array_length(_arr) == 0) return undefined;
	var _sorted = variable_clone(_arr);
    array_sort(_sorted, function(_a, _b) { return _a - _b; });
    var _len = array_length(_sorted);
    var _mid = _len div 2;

    if (_len mod 2 == 1) {
        return _sorted[_mid];
    } else {
        return (_sorted[_mid - 1] + _sorted[_mid]) / 2;
    }
}
