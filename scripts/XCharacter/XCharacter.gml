function XCharacter() : BaseCharacter() constructor{
	
	self.weapons = [xBuster, shotgunIce, boomerangCutter, electricSpark, stormTornado, fireWave, rollingShield, chameleonSting, homingTorpedo, SpinningWheel];
	
	self.init = function(_player){
		
		self.init_default(_player);
		with(_player){
			add_dash();
			add_wall_jump();
		}
	}
}