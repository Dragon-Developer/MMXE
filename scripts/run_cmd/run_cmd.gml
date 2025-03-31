var _cmd = argument[0];
var _args = argument;
switch (_cmd) {
	case "components_draw":
		ENTITIES.for_each_component(EntityComponentMask, function(_component) {
			_component.draw_enabled = true;
		});
		break;
}