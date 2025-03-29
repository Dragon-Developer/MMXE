function global_init() {
	ENTITIES = new EntityManager();
	GAME = new GameOffline();
	GAME.start();
}