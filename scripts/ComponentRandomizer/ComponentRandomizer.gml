function ComponentRandomizer(): ComponentBase() constructor{
	self.items = [];
	self.locations = [];
	
	self.check_room_stuff = function(){
		array_foreach(self.locations, function(_location){
			if(_location.randomizer_room == room){
				//get the old object's positions
				var _x = instance_id_get(_location.object_id).x;
				var _y = instance_id_get(_location.object_id).y;
				//destroy the old object
				ENTITIES.destroy_instance(_location.object_id);
				//replace it with a randomizer item
				//var _item = ENTITIES.create_instance(obj_randomizer_item,_x,_y);
				//set it to the location listed in the seed
				//var _seed = JSON.load(working_directory + "randomizer/" + global.randomizer_seed + ".json")
				//_item.components.item = variable_struct_get(variable_struct_get(_seed, "room"), "id")
			}
				
		})
	}
}

function RandomizerLocation() constructor{
	self.randomizer_room = rm_test;
	self.object_id = -1;
}

function RandomizerItem() constructor{
	self.type = "null";
	self.object = BasePickup;
}
