event_inherited();
entity_object = obj_capsule;
on_spawn = function(_player) {
	_player.components.publish("character_set", "stage");
	_player.components.find("animation").set_subdirectories(["/normal", "/light"]);
	_player.components.find("animation").play_animation( { name: "capsule" });
}
