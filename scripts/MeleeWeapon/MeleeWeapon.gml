function MeleeWeapon() : Weapon() constructor{
	self.term = "Melee";
	self.charge_limit = 0;
	self.cost = 0;
}

function MeleeData() constructor{
	self.term = "Melee"
	
	self.damage = 1;
	self.comboiness = 2;
	self.animation = "atk1";
	self.tag = ["enemy"];
	self.hitbox_scale = new Vec2(64,64);
	self.hitbox_offset = new Vec2(32,0);
	
	self.set_player_state = function(_plr, _charge){
		_plr.fsm.change("melee");
		_plr.states.melee.animation = self.animation;
	}
}

function MeleeProjectile(_animation, _length) : ProjectileData() constructor{
	self.hitbox_scale = new Vec2(64,64);
	self.hitbox_offset = new Vec2(32,0);
	self.term = "melee";
	self.piercing = true;
	self.animation = "xShot2";
	self.life_length = CURRENT_FRAME + _length;
	self.create = function(_inst){
		WORLD.play_sound("shoot_1");
	}
	self.step = function(_inst){
		
		if(self.life_length < CURRENT_FRAME){
			PROJECTILES.destroy_projectile(self);
		}
		
		_inst.x = instance_nearest(_inst.x, _inst.y, obj_player).x;
		_inst.y = instance_nearest(_inst.x, _inst.y, obj_player).y;
		
		if(instance_nearest(_inst.x, _inst.y, obj_player).components.get(ComponentPlayerMove).fsm.get_current_state() != "melee"){
			PROJECTILES.destroy_projectile(self);
		}
		
	}
}

function set_player_melee_info(_plr, _animation, _priority, _offset, _size, _damage, _reset_velocity = true){
	_plr.states.melee.animation = _animation;
	_plr.states.melee.priority = _priority;
	_plr.states.melee.hitbox_offset = _offset;
	_plr.states.melee.hitbox_scale = _size;
	_plr.states.melee.damage = _damage;
	_plr.states.melee.reset_velocity = _reset_velocity;
}