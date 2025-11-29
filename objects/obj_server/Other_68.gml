try{
	server.on_async_networking(async_load);
} catch(_err) {
	log(_err)
}