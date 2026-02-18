event_inherited();

components.add([
	ComponentEnemyManager,
	ComponentSpriteRenderer])

components.init();

self.create_enemy = function(_x, _y,_dir, _code){
	return components.get(ComponentEnemyManager).create_enemy(_x, _y,_dir, _code);
}
self.destroy_projectile = function(_proj){
	components.get(ComponentEnemyManager).destroy_enemy(_proj)
}