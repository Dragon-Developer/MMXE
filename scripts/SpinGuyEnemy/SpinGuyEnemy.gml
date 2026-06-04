function SpinGuyEnemy() : BaseEnemy() constructor{
	self.health = 5;
	
	self.sprite = "spin"
	
	self.step = function(_inst){
		_inst.x += dir;
		
		self.hitbox_scale = new Vec2(16, sin(ENEMIES.get_animation_index(self) / 8) * 8)
		
		if(instance_position(_inst.x + dir * 16, _inst.y + 20, obj_square_16) || instance_position(_inst.x + dir * 16, _inst.y - 4, obj_square_16)){
			dir *= -1;
		}
	}
}