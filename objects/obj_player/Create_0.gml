event_inherited();

components.add([
	ComponentInstance,
	ComponentPlayerInput,
	ComponentPlayerMove,
	ComponentPhysics,
	ComponentAnimationShadered,
	ComponentMask,
	ComponentWeaponUse,
	ComponentNode,
	ComponentDamageable,
	ComponentHealable
	//component input display should be on the camera. because its the camera, which only gets made once
]);

components.init();
