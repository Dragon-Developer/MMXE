function ComponentNPC() : ComponentInteractibleInteract() constructor{
	self.physics = noone;//so i can get if the player is colliding with the npc
	self.sprite = ["x", "idle"]
	self.face_player = false;
	
	self.dialouge = [
		{   sentence : "NPC ERROR!",
			mugshot_left : X_Mugshot_Happy1,
			mugshot_right : X_Mugshot1,
			focus : "left"
		}
	];
	
	self.init = function(){
		var _inst = self.get_instance();
	}
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
		});
	}
	
	self.Interacted_Script = function(_plr){
		if(!_plr.components.get(ComponentPlayerMove).physics.is_on_floor()) {self.interacted = false; return;}
		var _inst = self.get_instance();
		_plr.components.get(ComponentPlayerMove).locked = true;
		_plr.components.get(ComponentPlayerMove).fsm.trigger("t_dialouge");
		var _dialogue = ENTITIES.create_instance(obj_dialouge);
		_dialogue.x = _inst.x;
		_dialogue.y = _inst.y;
		_dialogue.components.get(ComponentDialouge).set_dialouge(dialouge, dialouge[0].mugshot_left, dialouge[0].mugshot_right);
		_dialogue.components.publish("change_dialouge",dialouge);
	}
		
	self.Interacted_Step = function(_plr)	{
		if(!instance_exists(obj_dialouge)){
			_plr.components.get(ComponentPlayerMove).locked = false;
			self.interacted = false;
		}
		
		if(_plr.x > self.get_instance().x && self.face_player){
			self.publish("animation_xscale", 1);
		}
		
		if(_plr.x <= self.get_instance().x && self.face_player){
			self.publish("animation_xscale", -1);
		}
	}
}