function ComponentArmorCapsule() : ComponentBase() constructor{
	self.has_opened = false;
	self.giving_armor = false;
	self.gave_armor = false;
	self.armor = ArmorDoubleGear;
	self.player = undefined;
	self.set_global_armor = true;
	self.global_armor_index = 0;
	self.give_time = undefined;
	self.already_equipped_armor = [];
	self.armor_slot_to_replace = 4;
	
	self.dialouge = [
		{   sentence : "You stupid!",
			mugshot_left : "x",
			mugshot_right : "x",
			focus : "left"
		}
	];
	
	self.init = function(){
		
		
	}
	
	self.step = function(){
		player ??= instance_nearest(0,0,obj_player);
		var _inst = self.get_instance();
		
		if(giving_armor){
			if(self.give_time > CURRENT_FRAME)
				WORLD.spawn_particle(new ArmorCapsuleParticle(_inst.x + irandom_range(-16,16), _inst.y - 48, 1))
			else if self.give_time == CURRENT_FRAME {
				player.components.get(ComponentArmorHandler).apply_full_armor_set(already_equipped_armor, "pose")
				player.components.get(ComponentPlayerMove).fsm.change("pose")
				
				if set_global_armor
					global.armors[global.character_index][armor_slot_to_replace] = global_armor_index;
			}
		} else if(has_opened){
			if(!instance_exists(obj_dialouge) && !giving_armor){
				player.components.get(ComponentPlayerMove).locked = false;
			}
			
			if(instance_position(_inst.x, _inst.y - 2, player)){
				giving_armor = true;
				player.x = _inst.x;
				player.y = _inst.y - 16;
				player.components.get(ComponentPlayerMove).locked = true;
				player.components.get(ComponentPhysics).set_hspd(0)
				player.components.publish("animation_play", { name: "idle" });
				WORLD.play_sound("armor_get");
				give_time = CURRENT_FRAME + 300;
				
				already_equipped_armor = player.components.get(ComponentArmorHandler).armor_structs;
				log(already_equipped_armor);
				already_equipped_armor[armor_slot_to_replace] = armor;
				for(var k = 0; k < array_length(global.availible_characters[global.character_index].possible_armors[armor_slot_to_replace]);k++){
					if(global.availible_characters[global.character_index].possible_armors[armor_slot_to_replace][k] == armor)
						global.armors[global.character_index][armor_slot_to_replace] = k;
				}
				
			}
		} else {
			if(abs(player.x - _inst.x) < 64 && abs(player.y - _inst.y + 32) < 64 && player.components.get(ComponentPhysics).is_on_floor()){
				has_opened = true;
				_inst = self.get_instance();
				player.components.get(ComponentPlayerMove).locked = true;
				player.components.get(ComponentPlayerMove).fsm.trigger("t_dialouge");
				if(self.dialouge.sentence != ""){
					var _dialogue = ENTITIES.create_instance(obj_dialouge);
					_dialogue.x = _inst.x;
					_dialogue.y = _inst.y;
					_dialogue.components.get(ComponentPlayerInput).set_player_index(player.components.get(ComponentPlayerInput).get_player_index())
					_dialogue.components.get(ComponentDialouge).set_dialouge(dialouge, dialouge[0].mugshot_left, dialouge[0].mugshot_right);
					_dialogue.components.publish("change_dialouge",dialouge);	
				}
				
			}
		}
	}
	
	self.draw = function(){
		if !global.debug return;
		var _arm = {}
		with(_arm){
			script_execute(other.armor)
		}
		
		draw_string_condensed(_arm.armor_name, self.get_instance().x, self.get_instance().y - self.get_instance().x / 12)
	}
}

function ArmorCapsuleParticle(_x, _y, _dir) : ParticleBase() constructor{
	self.sprite = "capsule_nugget";
	self.death_mode = "duration_frame";
	self.velocity = new Vec2(0,4);
	self.position = new Vec2(_x,_y);
	self.time = 0;
	self.time_max = 10;
	self.frame = 0;
	self.frame_max = 1;
	self.dir = _dir;
}