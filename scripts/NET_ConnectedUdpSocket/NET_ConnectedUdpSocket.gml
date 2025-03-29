function NET_ConnectedUdpSocket(_ip, _port) constructor {
	self.ip = _ip;
	self.port = _port;
	static toString = function() {
		return string("{0}:{1}", ip, port);
	}
}