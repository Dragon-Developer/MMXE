timer_delay_default = 70;
timer_delay = timer_delay_default;
timer_count = 3;

countdowning = true;

start_time = -1;

laps_left = global.race_laps - 1;
timer_paused = false;
prev_frame = -1;

final_time = -1;
WORLD.play_sound("rolling_shield_dink")