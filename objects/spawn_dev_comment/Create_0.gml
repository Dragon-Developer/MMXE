event_inherited();
entity_object = obj_dev_comment;
on_spawn = function(_player) {
	/*leave blank. this will be change in the creation code area*/
}


spawn = function() {
	
	if(!variable_struct_exists(global.settings, "dev_commentary")){
		global.settings.dev_commentary = false;
		instance_destroy(self);
		return;
	}
	if(!global.settings.dev_commentary){
		instance_destroy(self);
		return;
	}
	var _inst = ENTITIES.create_instance(entity_object);
	_inst.x = x;
	_inst.y = y;
	on_spawn(_inst);
	on_creation_spawn(_inst);
	
	_inst.components.get(ComponentPhysics).set_grav(new Vec2(0,0))
	_inst.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_inst.components.publish("character_set", "npc");
	_inst.components.publish("animation_play", { name: "forte" });
	_inst.depth += 32
	with(_inst.components.get(ComponentNPC)){
		step = function(){
			var _inst = self.get_instance();
			var _plr = self.physics.get_place_meeting(_inst.x, _inst.y, obj_player)
			if(_plr != noone){
				self.can_interact = true;
				self.Interacted_Step(_plr);
				if(_plr.components.get(ComponentPlayerInput).get_input_pressed_raw("up") && !self.interacted){
					self.Interacted_Script(_plr);
					self.interacted = true;
				}
			} else {
				self.can_interact = false;	
			}
		
			var _player = instance_nearest(get_instance().x, get_instance().y,obj_player);
			var _x = get_instance().x;
			var _y = get_instance().y;
			var _anim = ""
		
			//if the player is in front of you
			if(abs(_player.x - _x) < 16){
				//if the player is in front of you fr fr no cap
				if(abs(_player.y - _y) < 32){
					_anim = "forte_look_mc"
				//if the player is below you
				} else if(_player.y - _y < 0){
					_anim = "forte_look_mu"
				//if the player is above you
				} else {
					_anim = "forte_look_md"
				}
			//if the player is right of you
			} else if(_player.x - _x < 0){
				//if the player is in front of you fr fr no cap
				if(abs(_player.y - _y) < 32){
					_anim = "forte_look_rc"
				//if the player is below you
				} else if(_player.y - _y < 0){
					_anim = "forte_look_ru"
				//if the player is above you
				} else {
					_anim = "forte_look_rd"
				}
			//if the player is left of you
			} else {
				//if the player is in front of you fr fr no cap
				if(abs(_player.y - _y) < 32){
					_anim = "forte_look_lc"
				//if the player is below you
				} else if(_player.y - _y < 0){
					_anim = "forte_look_lu"
				//if the player is above you
				} else {
					_anim = "forte_look_ld"
				}
			}
		
			if(get(ComponentAnimation).animation.__animation != _anim)
				publish("animation_play", { name: _anim });
		
		}
	}
}