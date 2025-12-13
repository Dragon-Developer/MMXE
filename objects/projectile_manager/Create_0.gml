event_inherited();

components.add([
	ComponentProjectileManager,
	ComponentSpriteRenderer])

components.init();

self.create_projectile = function(_x, _y,_dir, _code, _shooter, _tags){
	return components.get(ComponentProjectileManager).create_projectile(_x, _y,_dir, _code, _shooter, _tags);
}

self.create_melee_hitbox = function(_x, _y,_dir, _code, _shooter, _tags, _animation, _length){
	return components.get(ComponentProjectileManager).create_melee_hitbox(_x, _y,_dir, _code, _shooter, _tags, _animation, _length);
}

self.get_collision = function(_object){
	return components.get(ComponentProjectileManager).get_collision(_object);
}

self.destroy_projectile = function(_proj){
	components.get(ComponentProjectileManager).destroy_projectile(_proj)
}