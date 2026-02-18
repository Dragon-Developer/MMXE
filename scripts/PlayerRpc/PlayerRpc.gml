function PlayerRpc(_is_server = false) constructor {
	self.socket = other;
	self.ping = 0;
	self.isServer = _is_server;
	self.register = function() {
		self.socket.rpc.registerHandler("update_armors", function(_params) {
			string_to_armor(_params.player_id, _params.armors)
			log("armors sent at least")
		});
		
		if(isServer){
			self.socket.rpc.registerHandler("send_armors", function(_params) {
				socket.rpc.sendNotification("update_armors", _params);
			}, socket.getAllSockets());
		}
	}
	self.send_armors = function(){
		socket.rpc.sendNotification("send_armors", {
			player_id: global.local_player_index,
			armors: global.player_data.last_used_armor
		});
	}
	self.register();
}

function string_to_armor(_index, _armor_array){
	var _possible_armors = global.player_character[_index].possible_armors;
	var _selected_armors = _armor_array;
		
	var _ret = array_create(array_length(_selected_armors))
		
	for(var p = 0; p < array_length(_selected_armors); p++){
		_ret[p] = _possible_armors[p][_selected_armors[p]]
	}
			
	global.armors[_index] = _ret;
}