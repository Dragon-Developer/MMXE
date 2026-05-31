if !lowered_gravoty && other.y > self.y{ 
	var _grav = other.components.get(ComponentPhysics)
	var _grav_y = _grav.grav_default.y / 2
	other.components.get(ComponentPhysics).grav_default = new Vec2(0, _grav_y)
	other.components.get(ComponentPhysics).grav = new Vec2(0, _grav_y)
	other.components.get(ComponentPhysics).grav_magnitude /= 2
	other.components.get(ComponentPhysics).terminal_velocity /= 2
	lowered_gravoty = true;
	log("LOWERED GRAVOTY")
}

if lowered_gravoty && other.y < self.y{ 
	var _grav = other.components.get(ComponentPhysics)
	var _grav_y = _grav.grav_default.y * 2
	other.components.get(ComponentPhysics).grav_default = new Vec2(0, _grav_y)
	other.components.get(ComponentPhysics).grav = new Vec2(0, _grav_y)
	other.components.get(ComponentPhysics).grav_magnitude *= 2
	other.components.get(ComponentPhysics).terminal_velocity *= 2
	lowered_gravoty = false;
	log("INCREASED GRAVOTY")
}