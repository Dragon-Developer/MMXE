// I wanted the utility of draw_string but i had no idea how it was made off the top of my head
function draw_string(_string, _x, _y){
	
	for(var q = 0; q < string_length(_string); q++){
		//log(string_char_at(_string, q + 1) + ", " +string(ord(string_char_at(_string, q + 1)) - 1))
		draw_sprite(spr_text_font_normal, ord(string_char_at(_string, q + 1)) - 33, _x + q * 8 - 4, _y);
	}
	
	/* fuck it we do a regular for loop
	string_foreach(_string, function(character,position){
		log(character);
		draw_sprite(spr_text_font_normal, 
		ord(character) - 1,
		other._x + position * 8 - 4, other._y);
	}) */
}