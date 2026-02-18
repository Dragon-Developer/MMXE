event_inherited();
entity_object = obj_manual_interactible;

self.sprite_set = "x";
self.animation = "idle";

self.interacted_script = function(_player) {
	log("This Object has no interact script defined!")
}

on_spawn = function(_player) {
	_player.components.get(ComponentInteractibleInteract).set_interacted_script(interacted_script);
	
	_player.components.find("animation").set_subdirectories([ "/normal"]);
	_player.components.publish("character_set", self.sprite_set)
	_player.components.publish("animation_play", { name: self.animation });
}
