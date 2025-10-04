event_inherited();
entity_object = par_pickup;
pickup_data = new Pickup();
on_spawn = function(_player) {
	_player.components.get(ComponentAnimationShadered).set_subdirectories([ "/normal"]);
	_player.components.get(ComponentPickup).data = pickup_data;
	_player.components.publish("character_set", "pickup");
	_player.components.publish("animation_play", { name: pickup_data.sprite });
}
