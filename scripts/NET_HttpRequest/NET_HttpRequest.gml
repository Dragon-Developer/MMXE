function NET_HttpRequest(_url, _method, _data, _headers, _params) : NET_BaseRequest() constructor {
    self.__url = _url;
    self.__method = _method;
    self.__data = _data;
    self.__headers = _headers;
    self.requestID = http_request(self.__url, _method, _headers, _data);
}
