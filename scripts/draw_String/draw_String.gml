// I wanted the utility of draw_string but i had no idea how it was made off the top of my head
function draw_string(_string, _x, _y){
	
	for(var q = 0; q < string_length(_string); q++){
		//log(string_char_at(_string, q + 1) + ", " +string(ord(string_char_at(_string, q + 1)) - 1))
		var _char = string_char_at(_string, q + 1)
		var _char_ord = ord(_char) - 33
		if _char == " " _char_ord = 3;
		if _char == "/" _char_ord = 14;
		if _char == "\\" _char_ord = 14;
		draw_sprite(spr_text_font_normal, _char_ord, _x + q * 8 - 4, _y);
	}
	
	/* fuck it we do a regular for loop
	string_foreach(_string, function(character,position){
		log(character);
		draw_sprite(spr_text_font_normal, 
		ord(character) - 1,
		other._x + position * 8 - 4, other._y);
	}) */
}

// corrupted showed off a thing where the text looked like regular text so I wanted to see 
function draw_string_condensed(_string, _x, _y){
	var _xx = 0;
	for(var q = 0; q < string_length(_string); q++){
		//log(string_char_at(_string, q + 1) + ", " +string(ord(string_char_at(_string, q + 1)) - 1))
		var _char = string_char_at(_string, q + 1)
		var _char_ord = ord(_char) - 33
		if _char == " " _char_ord = 3;
		if _char == "/" _char_ord = 14;
		if _char == "\\" _char_ord = 14;
		draw_sprite(spr_text_font_normal, _char_ord, _x + _xx, _y);
		_xx += string_get_text_length(_char);
	}
}

function string_get_text_length(_string){
	var _char = "";
	var _extreme_minors = [];// 5 px
	var _ultra_minors = [":",";","i","l","."];// 4 px
	var _minors = ["1", "r"," "];// minor characters. get your head out of the gutter.
	var _mediums = ["b","c","I","d","e","f","g","h","j","n","o","p","q","s","t","u","z"];// minors are 3px. mediums are 2. megas are 1.
	var _megas = ["E", "F","N","a","k","m","w","x","y","L"];
	var _xx = 0;
	for(var q = 0; q < string_length(_string); q++){
		_char = string_char_at(_string, q);
		if(array_contains(_extreme_minors,_char))
			_xx += 3;
		else if(array_contains(_ultra_minors,_char))
			_xx += 4;
		else if(array_contains(_minors,_char))
			_xx += 5;
		else if(array_contains(_mediums,_char))
			_xx += 6;
		else if(array_contains(_megas,_char))
			_xx += 7;
		else
			_xx += 8;
	}
	//log("The string is " + string(_xx) + " pixels wide")
	return _xx;
}