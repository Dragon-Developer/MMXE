function ComponentBar() : ComponentBase() constructor{
	coll1 = new Collage();
	healthBarCap = noone;
	hp = 2;
	maxhp = 20;  
	barLoopPoint = 64;
	barRepeatDistance = 14
	barOffsets = [new Vec2(12,78)];
	
	barCount = 1;
	barValues = [];
	barValueMax = [];
	barTypes = ["healthbar", "gigabar"]
	
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
		
		if global.debug draw_string(string(hp) + "/" + string(maxhp), barOffsets[0].x, barOffsets[0].y + 24)
		
		for(var g = 1; g < barCount; g++){
			self.draw_bar(barValues[g-1], barValueMax[g-1], barOffsets[g], "custom", barTypes[g - 1]);
		}
	}
	
	self.draw_bar = function(_val, _maxVal, _offset, _icon = PLAYER_SPRITE, _bar_type = "healthbar"){
		
		var _vertoffset = clamp(min(barLoopPoint, _maxVal) - 32, 0, 12000) * 2;
		//var _vertoffset = 0
		
		animation.draw_action(_bar_type + "_icon_" + _icon, undefined, 0, _offset.x, _offset.y + _vertoffset);//icon
		for(var i = 0; i <= _maxVal; i++)
		{			
			animation.draw_action(_bar_type + "_tick", undefined, 0, _offset.x + floor(i / barLoopPoint) * barRepeatDistance, _offset.y - 2 - ((i) mod barLoopPoint) * 2 + _vertoffset);//backing
			if(_val > i)
			{
				animation.draw_action(_bar_type + "_fill", undefined, 0, _offset.x + 4 + floor(i / barLoopPoint) * barRepeatDistance, _offset.y - 2 - ((i) mod barLoopPoint) * 2 + _vertoffset);//tick
			}
		}
		animation.draw_action(_bar_type + "_cap", undefined, 0, _offset.x + floor(i / barLoopPoint) * barRepeatDistance, _offset.y - 2 - ((i) mod barLoopPoint) * 2 + _vertoffset);//top
		
		for(var p = 0; p < floor(i / barLoopPoint); p++){
			animation.draw_action("healthbar_cap", undefined, 0, _offset.x + p * barRepeatDistance, _offset.y - 2 - barLoopPoint * 2 + _vertoffset);//top
			animation.draw_action("healthbar_icon_custom", undefined, 0, _offset.x + p * barRepeatDistance + barRepeatDistance, _offset.y - 2 + _vertoffset);//top
		}
	}
}