if(!instance_exists(obj_player)) return;

if(instance_nearest(xstart,ystart,obj_player).y + 15 < ystart){
	y = ystart;
} else {
	y = ystart -  1234567;//BIG NUMBAH
}