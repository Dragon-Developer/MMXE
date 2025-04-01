entity_object = noone;
spawn = function() {
var _inst = ENTITIES.create_instance(entity_object);
_inst.x = x;
_inst.y = y;
on_spawn(_inst);
}

on_spawn = function(_inst) {}