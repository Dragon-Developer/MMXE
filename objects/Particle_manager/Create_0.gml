event_inherited();

components.add([
	ComponentParticles,
	ComponentSpriteRenderer])

components.init();

self.add_particle = function(_x, _y,_dir, _code){
	return components.get(ComponentEnemyManager).add_particle(_x, _y,_dir, _code);
}