function NET_Wrapper() constructor {
	static __instance = noone;
	static __sockets = [];
	static get_instance = function() {
		if (!instance_exists(self.__instance)) {
			self.__instance = instance_create_depth(0, 0, 0, __net_wrapper);
		}
		return self.__instance;
	}
	static add = function(_socket) {
		array_push(self.__sockets, _socket);	
		self.get_instance();
	}
	static remove = function(_socket) {
		var _index = array_get_index(self.__sockets, _socket);
		if (_index == -1) return;
		array_delete(self.__sockets, _index, 1);	
	}
	static step = function() {
		array_foreach(self.__sockets, function(_socket) {
			_socket.step();
		});
	}
	static step_end = function() {
		array_foreach(self.__sockets, function(_socket) {
			_socket.step_end();
		});
	}
	static on_async_networking = function(_async_load) {
		array_foreach(self.__sockets, method( { _async_load }, function(_socket) {
			_socket.onAsyncNetworking(_async_load);
		}));
	}
	static on_async_http = function(_async_load) {
		NET_HttpWrapper.run_async(_async_load);
	}
}
new NET_Wrapper();