function BasePickup() constructor{
	self.count = 2;
	self.sound = undefined;
	self.delay = 60;
	self.skip_cond = "health_full";
	self.apply = function(_damageable){
		_damageable.heal(1, false);
	}
	self.sprite = "life_1"
}

function MediumHealthPickup() : BasePickup() constructor{
	self.count = 8;
	self.sprite = "life_2"
}

function HugeHealthPickup() : MediumHealthPickup() constructor{
	self.count = 64;
	self.sprite = "life_3"
}

function WeaponPickup() : BasePickup() constructor{
	self.skip_cond = "weapon_full";
	self.apply = function(_damageable){
		_damageable.get(ComponentWeaponUse).heal_ammo(1)
	}
	self.sprite = "wp_1"
}

function MediumWeaponPickup() : WeaponPickup() constructor{
	self.count = 8;
	self.sprite = "wp_2"
}

function HugeWeaponPickup() : MediumWeaponPickup() constructor{
	self.count = 64;
	self.sprite = "wp_3"
}



function HeartTankPickup() : BasePickup() constructor{
	self.sound = "collectible";
	self.delay = 130;
	self.skip_cond = "none";
	self.apply = function(_damageable){
		_damageable.add_max_health(1, false);
		if(!variable_struct_exists(global.player_data, "heart_tanks"))
			variable_struct_set(global.player_data, "heart_tanks", {})
		variable_struct_set(global.player_data.heart_tanks, room_get_name(room), true)
		global.player_data.max_health += 1
	}
	self.sprite = "heart"
}