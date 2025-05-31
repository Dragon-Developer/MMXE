event_inherited();
entity_object = par_enemy;

on_spawn = function(_player) {
	_player.components.publish("character_set", "x");
	//might get a base enemies folder. the subdirectories could be the different enemies
	_player.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
}
