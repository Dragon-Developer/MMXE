if parallax_layer == undefined return;

var _cam = instance_nearest(0,0,obj_camera)

layer_x(layer_get_id(parallax_layer), _cam.x * parallax_speed.x + parallax_offset.x)
layer_y(layer_get_id(parallax_layer), _cam.y * parallax_speed.y + parallax_offset.y)