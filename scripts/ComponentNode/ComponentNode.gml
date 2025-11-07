function ComponentNode() : ComponentBase() constructor{
	//ComponentNode stores references to children and their parent. 
	//a parent can have multiple children, but children do not require multiple parents. 
	self.node_parent = undefined;
	self.children_nodes = [];
	//self.previous_position = new Vec2(self.get_instance().x,self.get_instance().y);
	// dark wants me to use vector maths but i still dont understand what he means. 
	// i assume he means using velocity to change it, but some situations the parent
	// isnt moved by velocity
	
	//ill just make it a manual thing. its not that big of a deal.
	
	self.step = function(){
		return;
		array_foreach(self.children_nodes, function(_node){
			_node.get_instance().x += self.get_instance().x - self.previous_position.x;
			_node.get_instance().y += self.get_instance().y - self.previous_position.y;
		});
	}
	
	self.add_child = function(_child){
		//array push my beloved
		//i wish this wasnt unique to gamemaker. this just makes sense. 
		array_push(self.children_nodes, _child);
		_child.node_parent = self;
		with(_child){
			self.publish("child_connected_to_parent", other);
		}
		return _child;
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
	
	self.get_child = function(_index){
		return self.children[_index];
	}
}