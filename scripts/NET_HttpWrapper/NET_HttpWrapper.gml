function NET_HttpWrapper() constructor {
	static __pending_requests = [];
	static __instance = noone;
    
    static trackRequest = function(_request) {
		NET_Wrapper.get_instance();
        array_push(self.__pending_requests, _request);
    };

    static run_async = function(_async_load) {
	    var _id = _async_load[? "id"];
	    var _status = _async_load[? "status"];
	    var _http_status = _async_load[? "http_status"];
	    var _response = _async_load[? "result"];

	    var _index = array_find_index(self.__pending_requests, method({ reqID: _id },
	        function(req) { return req.requestID == reqID; }
	    ));

	    if (_index != -1) {
	        var _request = self.__pending_requests[_index];
	        array_delete(self.__pending_requests, _index, 1);

	        if (_http_status >= 200 && _http_status < 300) {
	            if (_status == 0) {
	                try {
	                    _response = json_parse(_response);
	                    _request.runCallback(_response);
	                } catch (e) {
	                    _request.runErrback({ code: -1, message: "JSON Parsing Error", details: e });
	                }
	            } else if (_status == 1) {
	                _request.runErrback({ code: 1, message: "Downloading..." });
	            } else if (_status < 0) {
	                _request.runErrback({ code: _status, message: "Error during request" });
	            }
	        } else {
	            try {
					_response = json_parse(_response);
					_response.code = _http_status;
	            } catch (e) {
	                _response = { code: -1, message: "Error details: Could not parse response." };
	            }

	            _request.runErrback(_response);
	        }
	    }
	};

};

new NET_HttpWrapper();
