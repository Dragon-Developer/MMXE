function ComponentHealthbar() : ComponentBase() constructor{
	coll1 = new Collage();
	healthBarCap = noone;
	hp = 2;
	maxhp = 20;  
	barOffsets = [new Vec2(12,78)];
	
	barCount = 1;
	barValues = [];
	barValueMax = [];
	
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
		
		self.draw_bar(hp, maxhp, barOffsets[0]);
		
		for(var g = 1; g < barCount; g++){
			self.draw_bar(barValues[g-1], barValueMax[g-1], barOffsets[g]);
		}
	}
	
	self.draw_bar = function(_val, _maxVal, _offset){
		draw_sprite(spr_bar1_icon, 0, _offset.x, _offset.y);
		for(var i = 0; i <= _maxVal; i++)
		{			
			draw_sprite(spr_bar1_area, 0, _offset.x, _offset.y - 2 - i*2);
			if(_val > i)
			{
				draw_sprite(spr_bar1_hp_unit, 0, _offset.x + 4, _offset.y - 2 - i*2);
			}
		}
		draw_sprite(spr_bar1_limit, 0, _offset.x, _offset.y - 2 - i*2);
	}
}