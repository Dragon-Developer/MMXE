function is_in_range(value, minimum, maximum) {
    return value > minimum && value < maximum;
}//just a useful util

function current_frame_in_range(value, minimum, maximum){
    return value > (minimum + CURRENT_FRAME) && value < (maximum + CURRENT_FRAME);
}//similarly useful, but in the lens of the better timer system