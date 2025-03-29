function NET_BaseRequest() constructor {
    self.__callbacks = [[]];
    self.__errbacks = [];
    self.__finally_method = undefined;
    self.__error_level = 0;
    self.__run_level = 0;
	self.__call = undefined;
	self.__timeout = undefined;
	
	static setTimeout = function(_timeout) {
		self.__timeout = _timeout;
		return self;
			
	}

    static onCallback = function(_callback) {
        array_push(self.__callbacks[self.__error_level], _callback);
        return self;
    };

    static onError = function(_errback) {
        array_push(self.__errbacks, _errback);
        self.__error_level += 1;
        if (self.__error_level >= array_length(self.__callbacks)) {
            self.__callbacks[self.__error_level] = [];
        }
        return self;
    };

    static onFinally = function(_finally) {
        self.__finally_method = _finally;
        return self;
    };

    static runCallback = function(_params) {
	    while (self.__run_level < array_length(self.__callbacks) && array_length(self.__callbacks[self.__run_level]) > 0) {
	        var _callback_array = self.__callbacks[self.__run_level];
	        var _callback = _callback_array[0];

	        try {
	            if (is_method(_callback)) {
	                var _callback_result = _callback(_params);

	                if (is_instanceof(_callback_result, NET_BaseRequest)) {
						array_delete(_callback_array, 0, 1);
	                    _callback_result.copy(self);
	                    return;
	                }
					_params = _callback_result;
	            }
	        } catch (_error) {
	            self.runErrback(_error);
	            return;
	        }

	        array_delete(_callback_array, 0, 1);
			
			if (array_length(_callback_array) == 0) {
	            self.__run_level += 1;
	        }
	    }
	    self.runFinally();
	};

    static runErrback = function(_error) {
        if (self.__run_level < array_length(self.__errbacks)) {
            var _errback = self.__errbacks[self.__run_level];

			try {
	            if (is_method(_errback)) {
	                _errback(_error);
	            }
	        } catch (_err) {
	            show_debug_message("Errback: " + string(_err));
	        }
			self.__run_level += 1;
        }
        self.runFinally();
    };

    static runFinally = function() {
        if (is_method(self.__finally_method)) {
            self.__finally_method();
        }
    };

    static cancel = function() {
        call_cancel(self.__call);
    };
	
	static start = function() {
		if (!is_undefined(self.__timeout)) {
			self.__call = call_later(self.__timeout, time_source_units_seconds, function() {
		        self.runErrback({ code: -1, message: "Timeout error" });
		    });
		}
	}
	
	static copy = function(_request) {
        self.__run_level = _request.__run_level;
		self.__error_level = _request.__error_level;
        self.__callbacks = _request.__callbacks;
        self.__errbacks = _request.__errbacks;
        self.onFinally(_request.__finally_method);
    };
}
