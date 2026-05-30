// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Is_X8_armor(_arm){
	switch(_arm){
		default:
		return false;
		case(XNeutralArmorArms):
		case(XNeutralArmorBody):
		case(XNeutralArmorBoot):
		case(XNeutralArmorHelm):
		case(XHermesArmorArms):
		case(XHermesArmorBody):
		case(XHermesArmorBoot):
		case(XHermesArmorHelm):
		case(XIcarusArmorArms):
		case(XIcarusArmorBody):
		case(XIcarusArmorBoot):
		case(XIcarusArmorHelm):
		case(XAresArmorArms):
		case(XAresArmorBody):
		case(XAresArmorBoot):
		case(XAresArmorHelm):
		return true;
	}
}