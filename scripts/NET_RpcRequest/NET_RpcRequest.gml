function NET_RpcRequest(_id, _timeout, _parent) : NET_BaseRequest() constructor {
    self.requestID = _id;
    self.parent = _parent;

    self.__call = call_later(_timeout, time_source_units_seconds, function() {
        var _requests = parent.requests;
        if (!_requests.hasElement(requestID)) return;
        var _request = _requests.getElement(requestID);
        _request.runErrback({ code: -32603, message: "Timeout error" });
        _requests.removeElement(requestID);
    });

    static isRPCRequest = function(_result) {
        if (!is_struct(_result)) return false;
        try {
            return is_instanceof(_result, NET_RpcRequest);
        } catch (err) {
            return instanceof(_result) == "NET_RpcRequest";
        }
    };
}
