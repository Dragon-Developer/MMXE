event_inherited();

components.add([
	ComponentEnemyManager,
	ComponentSpriteRenderer])

components.init();

self.create_enemy = function(_x, _y, _code){
	return components.get(ComponentEnemyManager).create_enemy(_x, _y, _code);
}

self.get_collision = function(_object){
	return components.get(ComponentEnemyManager).get_collision(_object);
}

self.destroy_enemy = function(_proj){
	components.get(ComponentEnemyManager).destroy_enemy(_proj)
}