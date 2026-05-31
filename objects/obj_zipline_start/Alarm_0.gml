if(end_point.x < 0){
	x += end_point.x;
	end_point.x *= -1;
}

if(end_point.y < 0){
	y += end_point.y;
	end_point.y *= -1;
	x += end_point.x;
	end_point.x *= -1;
}

self.depth = 200