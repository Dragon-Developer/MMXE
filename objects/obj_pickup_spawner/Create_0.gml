event_inherited();
entity_object = par_pickup;
pickup_data = new Pickup();
on_spawn = function(_player) {
	_player.components.get(ComponentAnimationShadered).set_subdirectories([ "/normal"]);
	_player.components.publish("character_set", "pickup");
}
