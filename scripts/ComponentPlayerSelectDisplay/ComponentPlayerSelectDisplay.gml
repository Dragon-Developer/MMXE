function ComponentPlayerSelectDisplay() : ComponentBase() constructor{

	self.armors = [];

	self.init = function(){
		self.publish("character_set", "x")
		find("animation").part_shaders = [new DummyShader(), new DummyShader(), new DummyShader(), new DummyShader(), new DummyShader()]
		find("animation").shaders = [new DummyShader()]
		self.publish("animation_play", { name: "select" });
		self.find("animation").set_surface_size(GAME_W * 2);
	}
	
	self.step = function(){
		if(find("animation").armors != armors){
			armors = find("animation").armors;
			
			find("animation").reload_animations();
		}
	}
}