function StringToCharacter(_string){
	switch(_string){
		default:
			return new XCharacter();
		case "zero":
			return new ZeroCharacter();
		case "megaman":
			return new RockCharacter();
		case "psx":
			return new psxCharacter();
	}
}