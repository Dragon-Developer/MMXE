function IcarusBuster() : ProjectileWeapon() constructor{
	self.data = [HermesBuster2Data,HermesBuster3Data,HermesBuster4Data,IcarusBigFuckoffLaserData];
	self.charge_limit = 4;
	self.cost = 0;
	self.title = "X BUSTER";
	self.description = "Mega Buster Mark 17"
	
	self.weapon_palette = [
		global.availible_characters[global.character_index].default_palette[0],
		global.availible_characters[global.character_index].default_palette[1],
		global.availible_characters[global.character_index].default_palette[2],
		global.availible_characters[global.character_index].default_palette[3],
		global.availible_characters[global.character_index].default_palette[4],
		global.availible_characters[global.character_index].default_palette[5]
	]
}

function IcarusBigFuckoffLaserData() : ProjectileData() constructor{
	self.animation = "icarus_beam";
	
	self.hitbox_scale = new Vec2(GAME_W,64);
	self.hitbox_offset = new Vec2(GAME_W / 2,0);
	self.invuln_rate = 0.25;
	self.piercing = true;
	self.super_piercing = true;
	self.life = 120;
	self.start_time = CURRENT_FRAME
	self.scale = 1;
	
	self.create = function(){
		with(instance_nearest(0,0,obj_player)){
			components.get(ComponentPlayerInput).__locked = true;
			components.get(ComponentPlayerMove).locked = true;
			components.get(ComponentPhysics).velocity = new Vec2(0, 0); 
			components.get(ComponentPhysics).grav = new Vec2(0, 0); 
			components.get(ComponentAnimationShadered).animation.__speed = 0;
			components.get(ComponentWeaponUse).shot_end_time += 180;
		}
	}
	
	self.step = function(_inst){
		if(self.start_time + self.life <= CURRENT_FRAME)
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
			
			
		_inst.x = floor(_inst.x)
		_inst.y = floor(_inst.y);
	}
	
	self.draw = function(_inst){
		self.vdir = 1 + sin(CURRENT_FRAME - pi / 2) / 15// * (27 / 47) * scale;
		draw_set_color(#0048ff)
		draw_rectangle(_inst.x + self.dir * 13, _inst.y - 13 + sin(CURRENT_FRAME) * scale, _inst.x + dir * GAME_W, _inst.y + 14 - sin(CURRENT_FRAME) * scale, false);
		draw_set_color(#0090ff)
		draw_rectangle(_inst.x+ self.dir * 13, _inst.y - 12 + sin(CURRENT_FRAME) * scale, _inst.x + dir * GAME_W, _inst.y + 13 - sin(CURRENT_FRAME) * scale, false);
		draw_set_color(#20d8ff)
		draw_rectangle(_inst.x+ self.dir * 13, _inst.y - 10 + sin(CURRENT_FRAME) * scale, _inst.x + dir * GAME_W, _inst.y + 11 - sin(CURRENT_FRAME) * scale, false);
		draw_set_color(#70ffff)
		draw_rectangle(_inst.x+ self.dir * 13, _inst.y - 8, _inst.x + dir * GAME_W, _inst.y + 8, false);
		draw_set_color(#f0ffff)
		draw_rectangle(_inst.x+ self.dir * 13, _inst.y - 7, _inst.x + dir * GAME_W, _inst.y + 7, false);
		draw_set_color(c_black)
	}
	
	self.destroy = function(){
		
		with(instance_nearest(0,0,obj_player)){
			components.get(ComponentPlayerInput).__locked = false;
			components.get(ComponentPlayerMove).locked = false;
			components.get(ComponentPhysics).grav = components.get(ComponentPhysics).grav_default
			components.get(ComponentPhysics).velocity = new Vec2(0, -1); 
			components.get(ComponentAnimationShadered).animation.__speed = 1;
			components.get(ComponentWeaponUse).shot_end_time = -1;
		}
	}
}