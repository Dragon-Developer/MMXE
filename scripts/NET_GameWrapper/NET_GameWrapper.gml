function NET_GameWrapper() constructor {
	static __games = [];
	static __instance = noone;
	static get_instance = function() {
		if (!instance_exists(__instance)) {
			__instance = instance_create_depth(0, 0, 0, __net_obj_game);	
		}
		return __instance;
	}
	static add = function(_game) {
		var _index = array_get_index(__games, _game);	
		if (_index != -1) return;
		array_push(self.__games, _game);
		get_instance();
	}
	static remove = function(_game) {
		var _index = array_get_index(__games, _game);	
		if (_index == -1) return;
		array_delete(__games, _index, 1);
	}
	static step = function() {
		array_foreach(__games, function(_game) {
			_game.step();
		});
	}
	static draw_gui = function() {
		array_foreach(__games, function(_game) {
			_game.draw_gui();
		});
	}
}
NET_GameWrapper();