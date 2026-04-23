// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function XSillyArmors() : BootPartBase() constructor{
	self.sprite_name = "/x1/legs"//this is more for filepath.
	self.armor_name = "silly Legs"
	self.apply_armor_effects = function(_player){
		add_slide(_player, self)
	}
	
	self.description = "Im a big boy now!"
}

function XGodBoots() : BootPartBase() constructor{
	self.sprite_name = "/x7/legs"//this is more for filepath.
	self.armor_name = "god Legs"
	self.apply_armor_effects = function(_player){
		add_slide(_player, self)
		add_high_jump(_player);
		add_air_dash(_player)
		add_ceil_cling(_player);
	}
	
	self.description = "The power of the sun in the ball of my foot!"
}

function XGodArms() : ArmsPartBase() constructor{
	self.sprite_name = "/x7/arms"//this is more for filepath.
	self.buster_weapon = ShadowBuster;
	self.armor_name = "god arms"
	self.apply_armor_effects = function(_player){
		
	}
	
	self.description = "I have yet to meet somebody who can outsmart bullet."
}

function XGodBody() : BodyPartBase() constructor{
	self.sprite_name = "/x7/body"//this is more for filepath.
	self.armor_name = "god pecs"
	damage_rate = 0;
	self.apply_armor_effects = function(_player){
		
	}
	
	self.description = "Damage? What's that?"
}

function XGodHelm() : HeadPartBase() constructor{
	self.sprite_name = "/x7/helm"//this is more for filepath.
	self.armor_name = "god brain"
	self.apply_armor_effects = function(_player){
		
	}
	
	self.description = "Charging is for losers!"
}