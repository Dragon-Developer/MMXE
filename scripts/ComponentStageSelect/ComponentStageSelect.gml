function ComponentStageSelector() : ComponentBase() constructor{
	// three phases: stage, player, armor
	
	// me personally, id like to move the player select step from after the stage select to an icon in
	// the stage select. this makes playing a stage easier
	
	// the player select itself is fine, though i think having a silhouette behind the player would be good. 
	
	// loading sprites is hard. would it be possible to make a componentsprite so I dont have to deal with
	// things like this? or would it be better to make a loadSprite function?
	
	self.init = function(){
		// how the fuck did dark load sprites for the animator?
		// if i can figure it out i can load sprites in with a single function, probably
		SpriteLoader.reload_collage(self.collage, "sprites/player", "normal");	
	}
}