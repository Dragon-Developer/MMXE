function StringToCharacter(_string){
	switch(_string){
		default:
			return new XCharacter();
			break;
		case "zero":
			return new ZeroCharacter();
			break;
		case "megaman":
			return new RockCharacter();
			break;
		case "psx":
			return new psxCharacter();
			break;
	}
}