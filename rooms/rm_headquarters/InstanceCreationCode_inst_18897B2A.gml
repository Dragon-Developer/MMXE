on_spawn = function(_bg){
	_bg.components.get(ComponentParallax).sprites = [just_the_hangar_without_the_lights_or_ships__2_]
	_bg.components.get(ComponentParallax).camera_move_rate = [0.1];
	_bg.components.get(ComponentParallax).xy_move_rate = [new Vec2(1,0)];
	_bg.components.get(ComponentParallax).reset_background();
	_bg.depth += 200
}