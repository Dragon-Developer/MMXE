function NET_PubSub_Topic(_id, _func) constructor {
	self.subscribers = {};
	static subscribe = function(_id, _func) {
		subscribers[$ _id] = _func;
	}
	static unsubscribe = function(_id) {
		struct_remove(subscribers, _id);
		return true;
	}
	static isSubscribed = function(_id) {
		return struct_exists(subscribers, _id);
	}
	static publish = function(_data) {
		data = _data;
		struct_foreach(subscribers, function(_id, _func) {
			_func(real(_id), data);
		});
	}
}