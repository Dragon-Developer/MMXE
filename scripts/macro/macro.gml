#macro ENTITIES global.entities
#macro SOUND global.soundManager
#macro GAME global.game
#macro WORLD global.world
#macro VBUTTON global.vbutton
#macro LOG global.logger
#macro GAME_W 320
#macro GAME_H 240
#macro CURRENT_FRAME floor((current_time / 1000) * 60)//this presumes that the program runs at 60 fps
//					This is also floored, because I want to cut off the decimal place specifically
//					most of the time, this number should be an integer for comparison reasons anyway
