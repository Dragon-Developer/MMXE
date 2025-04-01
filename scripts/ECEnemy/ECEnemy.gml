// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ECEnemy() : EntityComponentBase() constructor {	
	self.hp = 1;
	self.dir = 1;
	
	self.fsm = new SnowState("init", false);
	self.fsm.add("init",{})
	.add("idle", { 
			enter: function() {
				self.publish("animation_play", { name: "walk" });
			},
		})
	.add_transition("t_init", "init", "idle");
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new EntityComponentPhysicsBase();
		});
	}
	
	self.init = function() {
		self.fsm.trigger("t_init");
	}
}