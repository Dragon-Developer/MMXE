var _proj = false;
		
var _projectiles = PROJECTILES.components.get(ComponentProjectileManager).projectiles;
		
for(var u = 0; u < array_length(_projectiles); u++){
	var _test = get_struct_based_object_position(_projectiles[u]);
	if(_test != -1){
		_proj = _test
	}
}

if proj != false proj.deflected = true;