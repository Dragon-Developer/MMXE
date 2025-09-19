function XCharacter() : BaseCharacter() constructor{
	self.init = function(_player){
		self.weapons = [xBuster, SpinningWheel, SecondArmorRadar];
		self.init_default(_player);
		with(_player){
			add_dash();
			add_wall_jump();
		}
	}
}