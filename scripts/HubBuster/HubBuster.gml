function HubBuster() : ProjectileWeapon() constructor{
	self.data = [HubShot1,xBuster12Data,xBuster23Data,xBuster24_1Data,xBuster25_1Data];
	self.charge_limit = 4;
	self.cost = 0;
	self.title = "X BUSTER";
	self.description = "Upgraded Mega Buster"
	
	self.weapon_palette = [
		#a75229,//Blue Armor Bits
		#a75229,
		#a75229,
		#383038,//teal bits
		#383038,
		#383038
	];
}

function HubShot1() : ProjectileData() constructor{
	self.comboiness = -1;//youre limited by firing distance. keeping distance means less damage.
	self.damage = 1;
	self.shot_limit = 3;
	
	self.animation = "undefined";
	self.hitbox_scale = new Vec2(8,8);
	destroy = false
	self.precision = self.hitbox_scale.x - 1;
	
	self.create = function(_inst){
		WORLD.play_sound("shoot_1");
		WORLD.spawn_particle(new ExeFlashParticle(_inst.x + 16 * dir, _inst.y, self.dir))
		
		//move forwards until you hit a wall
		while(!instance_position(_inst.x, _inst.y, obj_square_16)){
			_inst.x += self.precision * self.dir;
		}
	}
	self.step = function(_inst){
		if destroy 
			PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(self) 
		else 
			destroy = true
	}
}


function ExeFlashParticle(_x, _y, _dir, _vy) : ParticleBase() constructor{
	self.sprite = "exe_flash";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,_vy);
	self.position = new Vec2(_x,_y);
	self.time_max = 2;
	self.frame_max = 3;
	self.dir = _dir;
}