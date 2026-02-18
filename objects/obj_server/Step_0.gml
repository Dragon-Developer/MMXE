log("server step " + step_loop++);
try{
	server.triggerEvent("step");
	server.network.step();
	log("dun did it")
} catch (_err){
	log(_err)
}