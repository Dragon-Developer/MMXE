function ComponentInputDisplay() : ComponentBase() constructor{
	input = noone;
	
	self.on_register = function(){
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input");
		});
	}
	
	self.draw_gui = function(){
		if(input == noone) return;
		
		draw_sprite(spr_input_controller, 0, 0, 0)
		draw_sprite(spr_input_controller, 1, 16, 0)
		
		draw_input(self.input.get_input("up") || self.input.get_input("down") || self.input.get_input("right") || self.input.get_input("left"), 6, 5, 9)
		
		draw_input(self.input.get_input("up"), 6, 5, 7);
		draw_input(self.input.get_input("down"), 6, 5, 11);
		draw_input(self.input.get_input("left"), 6, 3, 9);
		draw_input(self.input.get_input("right"), 6, 7, 9);
		
		draw_input(self.input.get_input("jump"), 6, 28, 8);
		draw_input(self.input.get_input("dash"), 6, 25, 11);
		draw_input(self.input.get_input("shoot"), 6, 25, 5);
		draw_input(self.input.get_input("shoot2"), 6, 22, 8);
		
		draw_input(true, 5, 12, 10);
		draw_input(true, 5, 17, 10);
		
		draw_input(self.input.get_input("switchLeft"), 9, 1, 2);
		draw_input(self.input.get_input("switchRight"), 10, 23, 2);
		
		draw_input(self.input.get_input("shoot3"), 4, 11, 2);
		draw_input(self.input.get_input("shoot4"), 4, 18, 2);
		
		//log(instance_number(par_projectile));
	}
	
	self.draw_input = function(_input, _frame, _x, _y){
		draw_sprite_ext(spr_input_controller, _frame, _x, _y,1,1,0,_input ? c_white : c_grey,_input ? 0.75 : 0.5);
	}
}

/*
self.setKeys([
		"left",
		"right",
		"up",
		"down",
		"jump",
		"dash",
		"shoot",
		"shoot2",
		"shoot3",
		"switchLeft",
		"switchRight"
	]);
*/