switch(transition_data.type){
	case "fade":
		if(transition_data.opacity > 0){
			transition_data.opacity += 1 / transition_data.visual_rate;
			draw_sprite_ext(transition_data.sprite, 0, 0, 0, 1, 1,0, c_white, transition_data.opacity);
	
			if(transition_data.opacity > 1){
				transition_data.visual_rate *= -1;
				if(transition_data.room != -1)
					room_goto(transition_data.room)
			}
		} else if(transition_data.opacity <= 0 && transition_data.transitioning){
			transition_data.transitioning = false;
		}
	break;
	case "white to black":
		if(transition_data.opacity > 0 || transition_data.opacity_2 > 0){
			transition_data.opacity += 1 / transition_data.visual_rate;
			draw_sprite_ext(spr_bright, 0, 0, 0, 1, 1,0, c_white, transition_data.opacity);
			draw_sprite_ext(transition_data.sprite, 0, 0, 0, 1, 1,0, c_white, transition_data.opacity_2);
	
			if(transition_data.opacity > 1 || transition_data.visual_rate <= 0){
				transition_data.opacity_2 += 1 / transition_data.visual_rate_2;
			}
			
			if(transition_data.opacity_2 > 1){
				transition_data.visual_rate *= -1;
				transition_data.visual_rate_2 *= -1;
				transition_data.opacity = -0.5;
				if(transition_data.room != -1)
					room_goto(transition_data.room)
			}
		} else if(transition_data.opacity_2 <= 0 && transition_data.visual_rate <= 0 && transition_data.transitioning){
			log("done transitioning")
			transition_data = {
				type: "fade",
				opacity: 0,
				opacity_2: 0,
				sprite: spr_fade,
				transitioning: false,
				visual_rate: 1,
				visual_rate_2: 1,
				room: -1
			}
		}
	break;
}
	
	
draw_string(global.local_player_index, 1, 1, "pause menu")