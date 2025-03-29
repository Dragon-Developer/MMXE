var _socket = async_load[? "socket"];
var _type = async_load[? "type"];
var _id = async_load[? "id"];
// Ignore if it's not from this client socket
if (_id != client.socket) return;
// Handle connection
if (_type == network_type_non_blocking_connect) {
	var _succeded = async_load[? "succeeded"];
	if (_succeded) {
		client.connected = true;
		client.triggerEvent("connected");
	} else {
		client.triggerEvent("error");
	}
}
// Handle data packets using RPC
else if (_type == network_type_data) {
	var _buffer = async_load[? "buffer"];
	try {
		client.network.processBuffer(_buffer, _id);
	} catch (_error) {
		client.triggerEvent("error", _error);
	}
}

