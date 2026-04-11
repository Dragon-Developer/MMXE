on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Do you wanna do a cutscene",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE,
			focus : "left",
			
			option_1 : "yes",
			option_1_function : function(){
				var _cut = instance_create_depth(0,0,0,obj_cutscene)
				var actions = [
					cutscene_move_player(new Vec2(880, 896)),
					cutscene_do_inputs([
						"R",
						40,
						"L",
						40,
						"RF",
						2,
						"LJ",
						2,
						"R",
						2,
						"L",
						2,
						"R",
						2,
						"L",
						2,
						"R",
						2,
						"L",
						2,
						"Maverick dead"
					], _cut),
					cutscene_add_dialouge([
						{   sentence : "Sick cutscene, am I right?",
							mugshot_left : "x",
							mugshot_right : PLAYER_SPRITE,
							focus : "left"
						}
					], _cut),
					cutscene_set_player_state("hurt")
				]
				_cut.components.get(ComponentCutscene).set_cutscene(actions);
			},
			option_2 : "yes",
			option_2_function : function(){
			}
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_npc.components.publish("character_set", "x");
	_npc.components.publish("animation_play", { name: "idle" });
	_npc.depth += 32
}