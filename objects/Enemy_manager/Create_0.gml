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
self.get_animation_frame = function(_reference){
	return components.get(ComponentEnemyManager).get_animation_frame(_reference)
}
self.get_nearest_enemy = function(_x, _y){
	return components.get(ComponentEnemyManager).find_nearest_enemy(_x, _y)
}
self.change_enemy_animation = function(_enemy, _animation){
	return components.get(ComponentEnemyManager).change_enemy_animation(_enemy, _animation)
}