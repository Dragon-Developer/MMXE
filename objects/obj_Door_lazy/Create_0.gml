//everything is going to be transported to a componentDoor eventually, but I dont want to clutter the folders just yet
time_delay = 45;
time_offset = -1;
activated = false;
state_segment = -1;// 1 is opening door, 2 is moving player through door, 3 is closing door, and -1 means the door is shut
multidirectional = false;//if its monodirectional, check the x scale
curr_player = noone;
curr_cam = noone;
camera_total_movement = GAME_W;

coll = instance_create_depth(x ,y,0, obj_square_16);
//coll.image_xscale = (sprite_width ) / 16;
//coll.image_yscale = sprite_height / 16;
alarm[0] = 1;