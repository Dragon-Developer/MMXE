event_inherited();

components.add([
	ComponentProjectileManager,
	ComponentSpriteRenderer])

components.init();

self.create_projectile = function(_x, _y,_dir, _code, _shooter, _tags){
	components.get(ComponentProjectileManager).create_projectile(_x, _y,_dir, _code, _shooter, _tags);
}

self.get_collision = function(_object){
	return components.get(ComponentProjectileManager).get_collision(_object);
}