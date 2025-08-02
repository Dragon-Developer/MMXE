
function ComponentInteractibleInteract() : ComponentInteractibleContact() constructor{
	self.can_interact = false;
	self.interact_prompt_offset = new Vec2(0, -32);
	
	self.step = function(){
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
	}
	
	self.draw = function(){
			if self.can_interact && !self.interacted{
				var _inst = self.get_instance();
				draw_sprite(spr_text_font_normal, 61, _inst.x + interact_prompt_offset.x, _inst.y + interact_prompt_offset.y)
			}
	}
}