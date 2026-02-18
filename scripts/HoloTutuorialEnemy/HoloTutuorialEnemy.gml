function HoloTutuorialEnemy() : BaseEnemy() constructor{
	self.health = 3;
	
	self.sprite = "skull_bot"
}

function HoloTutuorialEnemyWithShield() : HoloTutuorialEnemy() constructor{
	self.health = 2;
	self.sprite = "skull_bot_shield"
}