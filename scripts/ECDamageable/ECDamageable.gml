function ECDamageable() : ComponentBase() constructor{
	self.hp = 1;
	self.damage_rate = 1;
	self.combo_counter = 0;// for zero series comboing.
	self.invuln_timer = 0;// im sure dark is going to replace this with something like v1's system
	/*
	basically, projectiles have a combo number. if this combo number is below the combo counter,
	then the projectile can deal damage without giving a shit about invulnerability frames. 
	regular lemons would only have a combo counter of 0, so you can't deal extra damage. 
	
	combo counter is reset when invulnerability wears off
	*/
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			// this class doesnt need input because you cant move while damaged
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
		});
	}
}