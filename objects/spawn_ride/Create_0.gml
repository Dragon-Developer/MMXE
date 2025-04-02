event_inherited();
entity_object = par_ride;
on_spawn = function(_player){
	_player.components.get(EntityComponentAnimation).set_subdirectories(
	["/normal"]);
	_player.components.publish("character_set", "x");
	_player.components.publish("animation_play", { name: "jump"});
}