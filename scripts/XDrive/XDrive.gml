function XDrive() : ProjectileWeapon() constructor{
	self.data = [XDriveHandler];
	self.charge_limit = 0;
	self.refillRate = 1/30
	self.cost = 0;
	self.giga = true;
	self.not_selectable = true;
	self.title = "GAEA CRUSH";
	self.description = "LARGE RELEASE OF ABSORBED DAMAGE"
	
	self.weapon_palette = global.player_character[global.local_player_index].default_palette;
}

function XDriveHandler() : ProjectileData() constructor{
	self.animation_append = "_shoot";
	self.shot_limit = 1;
	self.comboiness = 1;//one full volley of lemons
	self.damage = 0;
	self.start_time = CURRENT_FRAME
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_1");
		instance_create_depth(_inst.x,_inst.y,-1000,obj_XDrive_Hander)
	}
	self.step = function(_inst){
		if(self.start_time + 3 == CURRENT_FRAME)
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
	}
	self.destroy = function(_inst){
	}
}