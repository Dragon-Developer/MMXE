log("THE END IS NEAR")

ENTITIES = new EntityManager();

with(all){
	if(!persistent)
		instance_destroy(self)
}