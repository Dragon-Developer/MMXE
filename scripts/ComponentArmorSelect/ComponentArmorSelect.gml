function ComponentArmorSelect() : ComponentBase() constructor{
	//dont really need the char select data, though it might still get copy pasted
	
	self.renderer = noone;
	
	self.init = function(){
		var _inst = self.get_instance();
		_inst.x = 0;
		_inst.y = 0;
		
		self.renderer = get(ComponentSpriteRenderer);
		get(ComponentSpriteRenderer).character = "char_select";
		get(ComponentSpriteRenderer).load_sprites();
		self.character_art = get(ComponentSpriteRenderer).add_sprite("x", true)
	}
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentPlayerInput();
		});
	}
	
	
}