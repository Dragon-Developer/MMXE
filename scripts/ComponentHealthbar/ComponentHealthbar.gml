function ComponentHealthbar() : ComponentBase() constructor{
	coll1 = new Collage();
	healthBarCap = noone;
	hp = 2;
	maxhp = 20;  
	screenOffsetX = 12;
	screenOffsetY = 78;
	
	
	compDamageable = noone;
	
	self.on_register = function(){
		self.subscribe("components_update", function() {
			self.compDamageable = self.parent.find("damageable");
		});
	}
	
	self.draw_gui = function() {
		
		if(compDamageable != noone){
			hp = compDamageable.health;
			maxhp = compDamageable.health_max;
		}
		
		draw_sprite(spr_bar1_icon, 0, screenOffsetX, screenOffsetY);
		for(var i = 0; i <= maxhp; i++)
		{			
			draw_sprite(spr_bar1_area, 0, screenOffsetX, screenOffsetY - 2 - i*2);
			if(hp > i)
			{
				draw_sprite(spr_bar1_hp_unit, 0, screenOffsetX + 4, screenOffsetY - 2 - i*2);
			}
		}
		draw_sprite(spr_bar1_limit, 0, screenOffsetX, screenOffsetY - 2 - i*2);
	}
	//need to learn collage! I need to load the UI texture folder!
}