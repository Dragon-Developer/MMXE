function ArmorBase() constructor{
	//name, sprite name, 
	self.armor_name = "undefined";
	self.sprite_name = "undefined";
	self.apply_armor_effects = function(_player){// _player is ComponentPlayerMove, not the associated instance
		log("This armor has no defined armor effect!");
	}
}