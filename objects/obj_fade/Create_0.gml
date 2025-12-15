last_input = 0;

log("Cock n ball torture")

transition_fade = function(_rate = 60){
	if(transition_data.transitioning) return;
	transition_data.type = "fade";
	transition_data.transitioning = true;
	transition_data.visual_rate = _rate;
	transition_data.opacity += 0.001;
}

transition_white_to_black = function(_rate = 60, _rate_2 = 60){
	transition_data.type = "white to black";
	transition_data.transitioning = true;
	transition_data.visual_rate = _rate;
	transition_data.visual_rate_2 = _rate_2;
	transition_data.opacity += 0.001;
}

transition_data = {
	type: "fade",
	opacity: 0,
	opacity_2: 0,
	sprite: spr_fade,
	transitioning: false,
	visual_rate: 1,
	visual_rate_2: 1
}