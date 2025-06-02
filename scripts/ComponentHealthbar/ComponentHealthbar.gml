function ComponentHealthbar() : ComponentBase() constructor{
	coll1 = new Collage();
	healthBarCap = noone;
	healthVar = 2;
	maxHealthVar = 20;  
	scrnOffset = 15;
	/*
	x offset from side of screen
	y offset, top of screen to bottom of healthbar
	health bar height
	health count 
	sprite for bottom carrier
	offset from bottom of healthbar to first health chunk
	
	*/
	
	/*self.step = function()
	{
		coll1.AddFile("datafiles/sprites/player/normal/spr_bar1_area_strip1.png", "spr_bar1_area_strip1", 1, false, false, 0, 0);
	}*/
	self.draw_gui = function() {
		draw_sprite(spr_bar1_icon, 0, scrnOffset, 120);
		for(var i = 0; i < maxHealthVar; i++)
		{			
			draw_sprite(spr_bar1_area, 0, scrnOffset, 118 - i*2);
			if(healthVar > i)
			{
				draw_sprite(spr_bar1_hp_unit, 0, scrnOffset + 4, 118 - i*2);
			}
		}
		draw_sprite(spr_bar1_limit, 0, scrnOffset, 118 - i*2);
	}
	self.init = function()
	{
		
	}
	//need to learn collage! I need to load the UI texture folder!
}