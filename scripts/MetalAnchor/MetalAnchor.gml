// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function MetalAnchor() : ProjectileWeapon() constructor{
	self.data = [MetalAnchorData,MetalAnchorData,MetalAnchorData,MetalAnchorSwarmSpawner,MetalAnchorSwarmSpawner];
	self.charge_limit = 3;

	self.title = "METAL A.";
	self.description = "HEAVY DAMAGE BOUNCING ANCHORS"
	
	self.weapon_palette = [
		#302870,//Blue Armor Bits
		#4050a8,
		#7088c8,
		#805858,//teal bits
		#c8b0a0,
		#f0f0d8
	];
}

function MetalAnchorData() : ProjectileData() constructor{
	self.comboiness = 6;
	
	self.shot_limit = 4;
	self.damage = 4;
	self.animation = "metal_anchor";
	self.grav = 0.1;
	self.vspd = -1;
	self.bounce_speed = -3.5;
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_2");
	}
	self.step = function(_inst){
		
		_inst.x += self.dir * 1;
		_inst.y += vspd;
		vspd += grav;
		
		if(instance_position(_inst.x, _inst.y - 8, obj_square_16) && vspd < 0){
			vspd *= -1;
		} else if(instance_position(_inst.x, _inst.y + 8, obj_square_16)){
			vspd = bounce_speed;
			_inst.y += bounce_speed * 2
			bounce_speed *= 0.9;
			
			if(abs(bounce_speed) < 0.75)
				PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
		}
			
		if(instance_position(_inst.x + 16 * dir, _inst.y, obj_square_16)){
			dir *= -1;
			bounce_speed *= 1.1;
		}
		log(dir)
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function MetalAnchorSwarmSpawner() : ProjectileData() constructor{
	self.comboiness = 6;
	
	self.shot_limit = 4;
	self.damage = 0;
	self.shot_time = CURRENT_FRAME + 360;
	self.animation = "undefined";
	self.grav = 0.1;
	self.vspd = -1;
	self.bounce_speed = -3.5;
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_2");
	}
	self.step = function(_inst){
		
		var	_x = instance_nearest(0,0,obj_camera).x - GAME_W / 2 + irandom_range(0, GAME_W * 1.5);
		var	_y = instance_nearest(0,0,obj_camera).y;
		
		if CURRENT_FRAME mod 6 == 0 {
			PROJECTILES.create_projectile(_x, _y, dir, MetalAnchorBerd, instance_nearest(0,0, obj_player).components.get(ComponentWeaponUse), tag);
		}
		
		if(shot_time < CURRENT_FRAME)
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
			
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new LemonDieParticle(_inst.x + 16, _inst.y, 1))
	}
}

function MetalAnchorBerd() : ProjectileData() constructor{
	self.comboiness = -1;
	self.damage = 4;
	self.animation = "metal_anchor_bird";
	self.create = function(_inst){
		WORLD.play_sound("shoot_2");
	}
	self.step = function(_inst){
		_inst.x += 2 * dir;
		_inst.y += 3;
	}
}