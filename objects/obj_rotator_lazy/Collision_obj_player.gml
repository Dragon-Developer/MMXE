if(!flipped){

		var _rotate = method({angle: 90}, function(_component) { _component.rotate_up(90) });
		ENTITIES.for_each_component(ComponentPhysics, _rotate);
		ENTITIES.for_each_component(ComponentAnimation, _rotate);
		ENTITIES.for_each_component(ComponentMask, _rotate);

	flipped = true;
}
foffset = CURRENT_FRAME + 60;