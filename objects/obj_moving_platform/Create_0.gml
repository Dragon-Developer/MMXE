event_inherited();
slick = false;
actually_moves_self = false;

self.local_offset_list = [[1,0, true, 1, true], [-1,0, false, 1, true]];//move p
self.move_rate = 0;//move rate is how many frames it takes to get to the location
self.total_moved = 0;
self.offset_index = 0;