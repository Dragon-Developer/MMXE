on_spawn = function(_object){
	_object.components.get(ComponentAnimation).set_subdirectories(
	["/armor/x1/legs"]);
	_object.components.publish("character_set", "x");
	_object.components.publish("armor_set",
	["x1_legs"]);
	_object.components.publish("animation_play", { name: "idle", frame: random_range(0,5) });
	_object.components.get(ComponentInteractibleContact).dies_after_interacting = true;
	_object.components.get(ComponentInteractibleContact).Interacted_Script = function(_player) {
		with(_player){
			var _move = self.components.get(ComponentPlayerMove);
			_move.add_dash();
			_move.reset_state_variables();
			_move.apply_armor_part(new XFirstArmorBoot());
		}
	}
	_object.components.get(ComponentPhysics).grav = new Vec2(0, 0);
	
}