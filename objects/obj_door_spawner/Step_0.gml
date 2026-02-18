on_spawn = function(_player) {
	_player.multidirectional = multidirectional;//oh god please dont ever do this in your project\
	_player.components.publish("character_set", "door");
}

event_inherited();

