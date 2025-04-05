// mmm im starting to not jive with entity components now
// i feel like this doesnt need components, because it's going to be
// used once in this object and nowhere else

// i will ask dark/gacel later. ill make a component and if they think
// its not needed i can just directly call step and draw from a variable
// set to a new version of the component.

event_inherited();

components.add([
	EntityComponentAnimation
	]);

components.init();