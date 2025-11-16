event_inherited();

components.add([
	ComponentDamageable,
	ComponentBoss,
	ComponentAnimationShadered,
	ComponentPhysics,
	ComponentMask
]);

components.init();

components.add([ComponentHealthbar]);