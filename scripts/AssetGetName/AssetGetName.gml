// taken from online. 
// specifically, https://forum.gamemaker.io/index.php?threads/asset_get_name.111511/
function asset_get_name(_asset)
{
    var type_ = asset_get_type(_asset)
 
    switch(type_)
    {
        case asset_object:
            return object_get_name(_asset);
        case asset_sprite:
            return sprite_get_name(_asset);
        case asset_sound:
            return audio_get_name(_asset);
        case asset_room:
            return room_get_name(_asset);
        case asset_tiles:
            return tileset_get_name(_asset);
        case asset_path:
            return path_get_name(_asset);
        case asset_script:
            return script_get_name(_asset);
        case asset_font:
            return font_get_name(_asset);
        case asset_timeline:
            return timeline_get_name(_asset);
        case asset_shader:
            return shader_get_name(_asset);
        case asset_animationcurve:
            return string(_asset);//idk how to get the name of these?
        case asset_sequence:
            return string(_asset);//idk how to get the name of these?
        case asset_particlesystem:
            {
                var _ps = part_system_get_info(_asset);
                return _ps.name;
            }
        case asset_unknown:
        default:
            return string(_asset);///not found
    }
}