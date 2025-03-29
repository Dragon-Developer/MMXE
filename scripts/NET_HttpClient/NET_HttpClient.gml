function NET_HttpClient() constructor {
    self.__base_url = "";

    static setBaseUrl = function(_url) {
        self.__base_url = _url;
    };

    static buildUrl = function(_url, _params) {
        var _full_url = self.__base_url + _url;
        if (!is_undefined(_params)) {
            var _query_string = "?";
            var _first = true;
            var _keys = struct_get_names(_params);
            for (var _i = 0, _len = array_length(_keys); _i < _len; _i++) {
				var _key = _keys[_i];
				var _value = _params[$ _key];
                if (!_first) 
					_query_string += "&";
                _query_string += _key + "=" + string(_value);
                _first = false;
            }
            _full_url += _query_string;
        }
        return _full_url;
    };

    static request = function(_url, _method, _body, _headers, _params) {
		var _full_url = self.buildUrl(_url, _params);
		var _map = json_decode(json_stringify(_headers));
		if (is_struct(_body)) {
			_map[? "Content-Type"] = "application/json";
		}
		_body = json_stringify(_body) ?? "";
        var _request = new NET_HttpRequest(_full_url, _method, _body, _map, _params);
		NET_HttpWrapper.trackRequest(_request);
        ds_map_destroy(_map);
		return _request;
    };

    static get = function(_url, _params = undefined, _headers = undefined) {
        return self.request(_url, "GET", undefined, _headers, _params);
    };
    static post = function(_url, _body = undefined, _headers = undefined) {
        return self.request(_url, "POST", _body, _headers, undefined);
    };
    static put = function(_url, _body = undefined, _headers = undefined) {
        return self.request(_url, "PUT", _body, _headers, undefined);
    };
    static patch = function(_url, _body = undefined, _headers = undefined) {
        return self.request(_url, "PATCH", _body, _headers, undefined);
    };
    static del = function(_url, _params = undefined, _headers = undefined) {
        return self.request(_url, "DELETE", undefined, _headers, _params);
    };
}