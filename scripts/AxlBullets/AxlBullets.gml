function AxlBullets() : AimableWeapon() constructor{
	self.data = [AxlBulletsData,CursePinchData];
	self.charge_limit = 0;
}

function AxlBulletsData() : AimableData() constructor{
	self.create = function(_plr){
		//var _angle = angle.angle()
	}
	
	self.spd = 5.5;
	
	self.step = function(_inst){
		var _angle = angle.angle() + 90;
		
		_inst.x += spd * sin(_angle / 180 * pi)
		_inst.y += spd * cos(_angle / 180 * pi)
	}
}