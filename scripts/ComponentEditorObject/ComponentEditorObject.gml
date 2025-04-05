// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ComponentEditorObject() : EntityComponentBase() constructor{
	self.xscale = 1;
	self.yscale = 1;
	self.rotation = 0;
	self.x = 0;// i want direct access variables. all the objects are really stacked up in the corner
	self.y = 0;
	self.object = obj_square_16;
	
	self.init = function(){
		
	}
	
	self.step = function(){
		var _inst = self.get_instance();
		self.xscale = _inst.image_xscale;
		self.yscale = _inst.image_yscale;
		//self.rotation = _inst.rotation;// unsure if this will stay. functionality to rotate isnt really needed, outside of sideways wall drills
	}
	
	self.draw = function(){
		draw_sprite(self.object.sprite_index,0,self.x,self.y);
	}
}