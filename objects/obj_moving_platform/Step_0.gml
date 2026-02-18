if(self.total_moved >= self.move_rate){
	self.total_moved = 0;
	self.offset_index = (self.offset_index + 1) mod array_length(local_offset_list);
	slick = local_offset_list[offset_index][2]
	move_rate = local_offset_list[offset_index][3]
	
	var _entity = instance_place(x, y - 1, obj_entity)
	
	if(_entity != noone && !slick){
		_entity.x += local_offset_list[offset_index][0] / move_rate;
		_entity.y += local_offset_list[offset_index][1] / move_rate;
	}
	
} else {
	if(actually_moves_self){
	x += local_offset_list[offset_index][0] / move_rate;
	y += local_offset_list[offset_index][1] / move_rate;
	}
	
	total_moved++;
	
	var _entity = instance_place(x, y - 1, obj_entity)
	
	if(_entity != noone && !slick){
		_entity.x += local_offset_list[offset_index][0] / move_rate;
		_entity.y += local_offset_list[offset_index][1] / move_rate;
	}
}