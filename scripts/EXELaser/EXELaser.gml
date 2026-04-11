// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function EXELaser() : ProjectileData() constructor{
	self.rotation = 0;
	self.intensity = new Vec2(0,6)
	self.animation = "undefined";
	self.commit_suicide = false;
	self.vscale = 20
	self.laser_gradient = 16
	
	self.create = function(_inst){
		//log(init_time)
	}
	
	self.step = function(_inst){
		
		if commit_suicide {
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
		} else {
			commit_suicide = true;
		}
	}
	
	self.draw = function(_inst){
		var _initial_x = _inst.x;
		var _initial_y = _inst.y;
		intensity = intensity.rotate(rotation)
		rotation += 45
		
		while(!instance_position(_inst.x, _inst.y, obj_square_16)){
			_inst.x += intensity.x;
			_inst.y += intensity.y;
			
			if(instance_position(_inst.x, _inst.y, obj_player)){
				var _plr = instance_position(_inst.x, _inst.y, obj_player);
				_plr.components.get(ComponentDamageable).take_damage(2);
			}
		}
		
		rotation *= -1
		
		for(var p = 0; p < laser_gradient; p++){
			draw_set_color(make_color_rgb(p * (256 / laser_gradient),p * (256 / laser_gradient / 2),p * (256 / laser_gradient)))
			vscale -= 1
		
			var _x1 = _initial_x + vscale * sin(rotation / 180 * pi)
			var _y1 = _initial_y + vscale * cos(rotation / 180 * pi)
			var _x3 = _inst.x + vscale * sin(rotation / 180 * pi)
			var _y3 = _inst.y + vscale * cos(rotation / 180 * pi)
		
			var _x2 = _initial_x + vscale * sin(rotation / 180 * pi + pi / 2)
			var _y2 = _initial_y + vscale * cos(rotation / 180 * pi + pi / 2)
			var _x4 = _inst.x + vscale * sin(rotation / 180 * pi + pi / 2)
			var _y4 = _inst.y + vscale * cos(rotation / 180 * pi + pi / 2)
		
			log(_x1)
			log(_x2)
		
			draw_primitive_begin_texture(pr_trianglestrip, -1);
			draw_vertex_texture(_x1, _y1, 0, 0); // Top-Left
			draw_vertex_texture(_x2, _y2, 1, 0); // Top-Right
			draw_vertex_texture(_x3, _y3, 0, 1); // Bottom-Left
			draw_vertex_texture(_x4, _y4, 1, 1); // Bottom-Right
			draw_primitive_end();
		}
		rotation += 45
		
		draw_sprite_ext(spr_cool_skull, 0, _inst.x, _inst.y, 2, 2, rotation, c_white, 1)
	}
}

function EXEBallRoof() : ProjectileData() constructor{
	self.going_down = false
	self.animation = "exe_circles";
	
	self.create = function(_inst){
		//log(init_time)
		//may make this default
		WORLD.play_sound("shoot_1");
	}
	
	self.step = function(_inst){
		if going_down
			_inst.y += 5
		else
			_inst.x += 5 * dir
			
		if(instance_position(_inst.x + 24 * dir, _inst.y, obj_square_16))
			going_down = true;
		if(instance_position(_inst.x, _inst.y + 24 , obj_square_16))
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new ExplosionParticle(_inst.x, _inst.y, 1))
	}
}

function EXEBallFloor() : ProjectileData() constructor{
	self.going_down = false
	self.animation = "exe_circles";
	
	self.create = function(_inst){
		//log(init_time)
		//may make this default
		WORLD.play_sound("shoot_1");
	}
	
	self.step = function(_inst){
		if going_down
			_inst.x += 5 * dir
		else
			_inst.y += 5
			
		if(instance_position(_inst.x, _inst.y + 24, obj_square_16))
			going_down = true;
		if(instance_position(_inst.x + 24 * dir, _inst.y , obj_square_16))
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self)
	}
	self.destroy = function(_inst){
		WORLD.spawn_particle(new ExplosionParticle(_inst.x, _inst.y, 1))
	}
}