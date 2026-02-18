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
	animation = new AnimationController("pause");
	static collage = new Collage();
	
	self.serializer = new NET_Serializer();
	self.sprites = new SpriteLoader();
	
	self.init = function(){
		sprites.reload_collage(self.collage,"sprites/healthbar", ["/normal"]);
		var _animation = JSON.load("sprites/pause/animation.json");
		if(_animation == -1) return;
		var _current_animation = undefined;
		if (!is_undefined(self.animation)) {
			_current_animation = self.animation.__animation;
		}
		self.animation
			.clear()
			.set_character("pause")
			.use_collage(collage)
			.add_type("hitbox") 
			.add_type("hurtbox") 
			.parse_data(_animation.data.animations)
			.init();
	}
	
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
		animation.draw_action("healthbar_icon_" + PLAYER_SPRITE, undefined, 0, _offset.x, _offset.y);//icon
		for(var i = 0; i <= _maxVal; i++)
		{			
			animation.draw_action("healthbar_tick", undefined, 0, _offset.x, _offset.y - 2 - i*2);//backing
			if(_val > i)
			{
				animation.draw_action("healthbar_fill", undefined, 0, _offset.x + 4, _offset.y - 2 - i*2);//tick
			}
		}
		animation.draw_action("healthbar_cap", undefined, 0, _offset.x, _offset.y - 2 - i*2);//top
	}
}