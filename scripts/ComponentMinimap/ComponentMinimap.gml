function ComponentMinimap() : ComponentBase() constructor{
	
	self.draw = function(){
		//Super metroid style coords
		//var _xoff = floor(player.x / GAME_W), _yoff = floor(player.y / GAME_H);
		//tile by tile coords
		var _xoff = floor(player.x / 16), _yoff = floor(player.y / 16);
		
		
		var _tileset = layer_tilemap_get_id("TS_Map")
		for(var w = 0; w < map_scale.x;w++){
			for(var h = 0; h < map_scale.y;h++){
				draw_point_color(w + camera_get_view_x(view_camera[0]) + GAME_W - map_scale.x,h + camera_get_view_y(view_camera[0]),
					tilemap_get(_tileset, 
					_xoff - map_scale.x / 2 + w,  _yoff - map_scale.y / 2 + h) == 0 ? #2028b0 : #a0b0f0
				)
			}
		}
		
		for(var i = 0;i<instance_number(obj_player);i++){
		    var _plr = instance_find(obj_player,i);

		    if (_plr.x - player.x) > GAME_W / -2 && (_plr.x - player.x) < GAME_W / 2 && 
				(_plr.y - player.y) > GAME_H / -2 && (_plr.y - player.y) < GAME_H / 2{
				draw_point_color((_plr.x - player.x) / 16 + camera_get_view_x(view_camera[0]) + GAME_W - map_scale.x / 2
					,(_plr.y - player.y) / 16 + camera_get_view_y(view_camera[0]) + map_scale.y / 2,#ff2030);
			}
		}
	}
	
	self.player = noone;
	
	self.map_scale = new Vec2(32,16);
	
	self.init = function(){
		log("mininit")
		var _inst = self.get_instance();
		self.player = instance_nearest(_inst.x, _inst.y, obj_player);
	}
	
	
}