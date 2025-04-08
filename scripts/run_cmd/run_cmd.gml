var _cmd = argument[0];
var _args = argument;
switch (_cmd) {
	case "components_draw":
		ENTITIES.for_each_component(ComponentMask, function(_component) {
			_component.draw_enabled = true;
		});
		break;
}