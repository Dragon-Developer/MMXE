function ComponentAnimationMultiple() : ComponentAnimation() constructor {
	//so basically, it has a list of animation controllers and every frame it iterates through them
	
	self.add_tags("AnimationMultiple");
	self.animators = [new AnimationController()];
	self.animation = self.animators[0];
	self.active_animator = 0;
	
	self.on_register = function() {
		self.subscribe("character_set", function(_character) {
			self.character = _character;
			self.reload_animations();
		});
		self.subscribe("armor_set", function(_armors){
			self.armors = _armors;
		});
		self.subscribe("animation_play", function(_animation) {
			//log(_animation.name);
			_animation[$ "reset"] ??= false;
			_animation[$ "keep_index"] ??= false;
			var _index = self.animation.get_index();
			self.animators[self.active_animator].play(_animation.name, _animation.reset);
			if (_animation.keep_index) {
				self.animators[self.active_animator].set_index(_index);	
			}
		});
		
		self.subscribe("animation_play_at_loop", function(_animation) {
			_animation[$ "reset"] ??= false;
			_animation[$ "keep_index"] ??= false;
			var _index = self.animation.get_index();
			self.animators[self.active_animator].play_at_loop(_animation.name, _animation.reset);
			if (_animation.keep_index) {
				self.animators[self.active_animator].set_index(_index);	
			}
			self.animators[self.active_animator].__frame = _animation.frame;
		});
		self.subscribe("animation_xscale", function(_xscale) {
			self.animators[self.active_animator].set_xscale(_xscale)
		});
		self.subscribe("animation_visible", function(_visible) {
			self.animators[self.active_animator].set_visible(_visible)
		});
		self.subscribe("animation_set_controller", function(_controller) {
			self.active_animator = _controller
		});
		self.subscribe("animation_add_controller", function() {
			array_push(self.animators, new AnimationController());
		});
	}
	
	self.draw = function(){
		for(var e = 0; e < array_length(self.animators); e++){
			self.animation = self.animators[e];
			self.draw_regular();
		}
	}
}