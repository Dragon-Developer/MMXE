function FortState(_initState, _execEnter = true) : SnowState(_initState, _execEnter = true) constructor {	
	__remove = function(_name){
		//if the state exists, kill it with fire!
		if(variable_struct_exists(__states, _name))
			variable_struct_remove(__states, _name);
			
		//get all struct names for the transitions
		var keys = variable_struct_get_names(__transitions);
		//iterate through all of the variables in the struct
		for (var i = array_length(keys)-1; i >= 0; i--) {
		    var k = keys[i];
		    var v = __transitions[$ k];
		    
			//iterate through all of the variables in the variable we just got in the struct. Structs in structs!
			var keys2 = variable_struct_get_names(v);
			for (var i2 = array_length(keys2)-1; i2 >= 0; i2--) {
			    var k2 = keys2[i2];
			    var v2 = v[$ k2];
				log(v2)
				
				//if the 'to' variable is the same as the provided name, kill it with fire!
				for(var p = 0; p < array_length(v2); p++){
					if(v2[p].to == _name){
						array_delete(__transitions[$ k][$ k2], p, 1)
					}
				}
			}
		}
		
		keys = variable_struct_get_names(__wildTransitions);
		//iterate through all of the variables in the struct
		for (var i = array_length(keys)-1; i >= 0; i--) {
		    var k = keys[i];
		    var v = __wildTransitions[$ k];
			log(v)
				
			//if the 'to' variable is the same as the provided name, kill it with fire!
			for(var p = 0; p < array_length(v); p++){
				if(v[p].to == _name){
					array_delete(__wildTransitions[$ k], p, 1)
				}
			}
		}
		
		/*
		
		transitions variable format
		- state
			- transition name
				- state to transition to
		
		*/
		
		//update the states
		__update_states();
		
		log(_name + " removed")
		
		return self;
	}
	
	remove = function(_name){
		__remove(_name)
		return self;
	}
	
	__get_all_states = function(){
		return variable_struct_get_names(__states);
	}
	
	get_all_states = function(){
		return __get_all_states();
	}
	
	__func_exec = function(_func, _args = undefined) {
		if (_args == undefined) return _func();
		if (!is_array(_args)) return _func(_args);
		
		return script_execute_ext(_func, _args);
	};
	
	Log("FortState Initalized")
}

show_debug_message("FortState exists")