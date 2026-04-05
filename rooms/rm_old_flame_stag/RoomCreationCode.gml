with(obj_conveyor_belt){
	var _block = instance_create_depth(x, y, depth, obj_square_16)
	_block.image_xscale = image_xscale;
	_block.image_yscale = image_yscale;
	instance_destroy(self)
}