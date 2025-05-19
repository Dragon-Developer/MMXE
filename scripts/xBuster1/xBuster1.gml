function xBuster1() : ProjectileWeapon() constructor{
	self.data = xBuster1Data;//hmmm
	self.charge_time = 60;//i dont think mmxe uses this, but battle network has some busters charge faster than others
	self.animation_name = noone;//if its noone, then assume its _shoot. 
}

function xBuster1Data() : ProjectileData() constructor{
	//the lemon
	self.comboiness = 3;//one full volley of lemons
	self.create = function(_inst){
		//may make this default
		_inst.components.publish("animation_play", { name: "shot" });
	}
	self.step = function(_inst){
		_inst.x += self.dir;
		draw_sprite(spr_editor_icons,0,_inst.x, _inst.y);
	}
}