function AxlBullets() : AimableWeapon() constructor{
	self.data = [AxlBulletsData,CursePinchData];
	self.charge_limit = 0;
}

function AxlBulletsData() : AimableData() constructor{
	self.create = function(_plr){
		//var _angle = angle.angle()
	}
	
	self.step = function(_inst){
		var _angle = angle.angle() + 90;
		
		_inst.x += 3 * sin(_angle / 180 * pi)
		_inst.y += 3 * cos(_angle / 180 * pi)
	}
}