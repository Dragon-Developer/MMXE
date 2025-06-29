function ComponentNode() : ComponentBase() constructor{
	//ComponentNode stores references to children and their parent. 
	//a parent can have multiple children, but children do not require multiple parents. 
	self.node_parent = undefined;
	self.children_nodes = [];
	self.previous_position = new Vec2(self.get_instance().x,self.get_instance().y);
	
	self.step = function(){
		array_foreach(self.children_nodes, function(){
			self.get_instance().x += other.get_instance().x - other.previous_position.x;
			self.get_instance().y += other.get_instance().y - other.previous_position.y;
		});
	}
	
	self.add_child = function(_child){
		//array push my beloved
		//i wish this wasnt unique to gamemaker. this just makes sense. 
		array_push(self.children_nodes, _child);
	}
	
	self.remove_child = function(_child){
		// loop through all children
		for(var t = 0; t < array_length(self.children_nodes); t++){
			//if the child that we want to get rid of exists
			if(self.children_nodes[t] == _child){
				//then we delete the child
				array_delete(self.children_nodes, t, 1);
				//the child is deleted, so we dont have to look at the rest
				break;
			}
		}
	}
}