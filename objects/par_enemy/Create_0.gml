event_inherited();

components.add([
	ComponentDamageable,
	ComponentEnemy,//think ill keep these split, so there can be invuln enemies
	//like the first vile fight in x1
	ComponentAnimation,
	ComponentPhysics,
	ComponentMask
]);

components.init();