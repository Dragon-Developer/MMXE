global.gui.draw();

if(!global.gui.usingMouse && !global.gui.hudContainer.enabled){
	draw_sprite(spr_gamepad_reticle, frame, global.gui.mouseX, global.gui.mouseY);
}

frame = (frame + 0.25) mod 6