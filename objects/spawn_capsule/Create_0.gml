event_inherited();
entity_object = obj_capsule;
self.dialouge = [
		{   sentence : "You real stupid!",
			mugshot_left : "x",
			mugshot_right : "x",
			focus : "left"
		}
	];
on_spawn = function(_player) {
	
	_player.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_player.components.publish("character_set", "npc");
	_player.components.publish("animation_play", { name: "capsule" });
	
	_player.components.get(ComponentArmorCapsule).dialouge = dialouge;
	
	var _bottom_block = instance_create_depth(_player.x - 16, _player.y, 0, obj_square_16)
	_bottom_block.image_xscale = 2;
	var _top_block = instance_create_depth(_player.x - 16, _player.y - 72, 0, obj_square_16)
	_top_block.image_xscale = 2;
	_top_block.image_yscale = 2;
}
