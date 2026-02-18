// Feather disable all

//This script contains the default profiles, and hence the default bindings and verbs, for your game
//
//  Please edit this macro to meet the needs of your game!
//
//The struct return by this script contains the names of each default profile.
//Default profiles then contain the names of verbs. Each verb should be given a binding that is
//appropriate for the profile. You can create bindings by calling one of the input_binding_*()
//functions, such as input_binding_key() for keyboard keys and input_binding_mouse() for
//mouse buttons

function __input_config_verbs()
{
    return {
        keyboard_and_mouse:
        {
            up:    [input_binding_key(vk_up)],
            down:  [input_binding_key(vk_down)],
            left:  [input_binding_key(vk_left)],
            right: [input_binding_key(vk_right)],
            
            jump:        input_binding_key("V"),//gonna be jump
            dash:        input_binding_key("D"),// gonna be dash
            shoot:       input_binding_key("X"),// shoot
            shoot2:      input_binding_key("C"),// alt shoot
            shoot3:      input_binding_key("Z"),// gigas
            shoot4:      input_binding_key("f"),// power gear / alt gigas
            switchLeft:  input_binding_key("A"),// switch weapon to the left
            switchRight: input_binding_key("S"),// switch weapon to the right
            
            //No aiming verbs since we use the mouse for that (see below for aiming verb examples)
			click: input_binding_mouse_button(mb_left),
            
            pause: input_binding_key(vk_enter),
        },
        
        gamepad:
        {
            up:    [input_binding_gamepad_axis(gp_axislv, true),  input_binding_gamepad_button(gp_padu)],
            down:  [input_binding_gamepad_axis(gp_axislv, false), input_binding_gamepad_button(gp_padd)],
            left:  [input_binding_gamepad_axis(gp_axislh, true),  input_binding_gamepad_button(gp_padl)],
            right: [input_binding_gamepad_axis(gp_axislh, false), input_binding_gamepad_button(gp_padr)],
            
            jump:        input_binding_gamepad_button(gp_face1),
            dash:        input_binding_gamepad_button(gp_face2),
            shoot:       input_binding_gamepad_button(gp_face3),
            shoot2:      input_binding_gamepad_button(gp_face4),
            shoot3:      input_binding_gamepad_button(gp_shoulderlb),
            shoot4:      input_binding_gamepad_button(gp_shoulderrb),
            switchLeft:  input_binding_gamepad_button(gp_shoulderl),
            switchRight: input_binding_gamepad_button(gp_shoulderr),
            
            aim_up:    input_binding_gamepad_axis(gp_axisrv, true),
            aim_down:  input_binding_gamepad_axis(gp_axisrv, false),
            aim_left:  input_binding_gamepad_axis(gp_axisrh, true),
            aim_right: input_binding_gamepad_axis(gp_axisrh, false),
            //shoot:     [input_binding_gamepad_button(gp_shoulderlb), input_binding_gamepad_button(gp_shoulderrb)],
            
            pause: input_binding_gamepad_button(gp_start),
        },
        
        touch:
        {
            up:    input_binding_virtual_button(),
            down:  input_binding_virtual_button(),
            left:  input_binding_virtual_button(),
            right: input_binding_virtual_button(),
            
            jump:        input_binding_virtual_button(),
            dash:        input_binding_virtual_button(),
            shoot:       input_binding_virtual_button(),
            shoot2:      input_binding_virtual_button(),
            shoot3:      input_binding_virtual_button(),
            shoot4:      input_binding_virtual_button(),
            switchLeft:  input_binding_virtual_button(),
            switchRight: input_binding_virtual_button(),
            
            pause: input_binding_virtual_button(),
        }
    };
}