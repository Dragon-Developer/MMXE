function TestBoss() : BaseBoss() constructor {
	// Dialogue, not really used.
	self.dialouge = [{
		sentence : "Wait. Who are you? This is not part of the training simulation.",
		mugshot_left : PLAYER_SPRITE,
		mugshot_right : "ix",
		focus : "left"
	}, {
		sentence : "Heh, you really forgot your old pal, X?",
		mugshot_left : PLAYER_SPRITE,
		mugshot_right : "ix",
		focus : "right"
	}, {
		sentence : "Fine, doesn't matter. I'll tear you down and get out of this place.",
		mugshot_left : PLAYER_SPRITE,
		mugshot_right : "ix",
		focus : "right"
	}];
	// Specify what animation are we using for the boss.
	self.image_folder = "ix";
	self.subdirectories = ["/normal"];
	// Start wit the fall animation.
	self.init = function(_par){
		_par.publish("animation_play", { name: "fall" });
	}
	// Specify default animations.
	self.pose_animation_name = "idle";
	self.intro_animation_name = "fall";
	self.death_animation_name = "hurt";

	// Local functions for stuff that is repeated.
	self.check_player_wallclimb = function(boss) {
		var actor = boss.get_instance();
		var nearPlayer = instance_nearest(actor.x, actor.y, obj_player);
		var localPhysics = actor.components.get(ComponentPhysics);
		// If the enemy is cheesing on a wall.
		if (localPhysics.check_place_meeting(
			nearPlayer.x + 16,
			nearPlayer.y - 2,
			obj_square_16
		) ||
			localPhysics.check_place_meeting(
			nearPlayer.x - 16,
			nearPlayer.y - 2,
			obj_square_16
		)) {
			return true;
		}
		return false;
	}

	// Add states.
	self.add_states = function(_player) {
		// We set up the namespace to the object.
		with(_player) {
			// Animations and intro sprites.
			self.pose_animation_name = other.pose_animation_name;
			self.intro_animation_name = other.intro_animation_name;
			self.death_animation_name = other.death_animation_name;
			self.has_dialouge = true;
			self.dialouge = other.dialouge
			self.check_player_wallclimb = other.check_player_wallclimb;
			// Set up gravity, animations and other stuff.
			self.get(ComponentPhysics).set_grav(new Vec2(0, 0.25));
			self.attack_states = ["dash_start", "jump_start", "shoot", "shoot2"];
			self.lowhp_states = ["dash_start", "jump_start", "shoot", "shoot2", "giga_charge"];	
			self.wall_states = ["dash_start", "jump_start"]
			self.lowhp_wall_states = ["giga_charge", "jump_start"]
			self.timer = -1;
			self.startTime = CURRENT_FRAME;
			self.desperate_rate = 1/4;
			self.contact_damage = 2;
			self.max_health = 28;

			// Idle state, our main state.
			// We go to others from here.
			fsm.add("idle", {
				// Enter, runs once we enter.
				enter: function() {
					// Set up anim and face player.
					self.face_player();
					self.publish("animation_xscale", self.dir);
					self.publish("animation_play", { name: "idle" });
					// Set up start time to keep track.
					self.startTime = CURRENT_FRAME;
					// Set hspeed to 0. In case other state did not.
					self.get(ComponentPhysics).set_hspd(0);
				},
				// Step, runs each frame.
				step: function() {
					// Wait 20 frames.
					if (CURRENT_FRAME - self.startTime < 20) {
						return;
					}
					// Face the enemy.
					self.face_player();
					self.publish("animation_xscale", self.dir);
					// States to pick from.
					var targetStates = self.attack_states;
					// Low HP states.
					if (desperate) {
						targetStates = lowhp_states;
					}
					// Distance stuff.
					var actor = self.get_instance();
					var nearPlayer = instance_nearest(actor.x, actor.y, obj_player);
					var localPhysics = actor.components.get(ComponentPhysics);
					// If the enemy is cheesing on a wall.
					if (nearPlayer.y - actor.y <= -80 && self.check_player_wallclimb(self)) {
						if (desperate) {
							targetStates = self.lowhp_wall_states;
						} else {
							targetStates = self.wall_states;
						}
					}
					// Select a random state from the attack_states array.
					self.fsm.change(targetStates[random_value mod array_length(targetStates)]);
				},
				// Leave, runs once we change state.
				leave: function() {
				}
			})
			// Shoots big lemons.
			fsm.add("shoot", {
				enter: function() {
					// Anim stuff.
					self.face_player();
					self.publish("animation_xscale", self.dir);
					self.publish("animation_play", { name: "shoot" });
					self.startTime = CURRENT_FRAME;
					// Local variables to keep track of.
					self.shootNum = 0;
					self.maxShoot = (random_value mod 3) + 2;
					self.hasShot = false;
				},
				step: function() {
					// Check if we are in shoot frame.
					// If we do and have not shoot then we shoot.
					if (!self.hasShot && CURRENT_FRAME - self.startTime >= 4) {
						// Create projectile as enemy flag.
						PROJECTILES.create_projectile(
							self.get_instance().x + (14 * self.dir),
							self.get_instance().y - 4,
							self.dir, TestBossBuster,
							get(ComponentWeaponUse), ["enemy"], 0
						);
						// Play shoot sound.
						WORLD.play_sound("shoot_2");
						// Set flags and increase the counter.
						self.hasShot = true;
						self.shootNum++;
					}
					// Aim at the player.
					// This is done later so he can miss shots.
					if (CURRENT_FRAME - self.startTime >= 15) {
						self.face_player();
						self.publish("animation_xscale", self.dir);
					}
					// Animation ended.
					if (CURRENT_FRAME - self.startTime >= 21) {
						// If we have shoot enough we exit.
						if (self.shootNum >= 3) {
							self.fsm.change("idle");
							return;
						}
						// Otherwise we reset stuff.
						self.hasShot = false;
						self.startTime = CURRENT_FRAME;
						self.publish("animation_play", { name: "idle" });
						self.publish("animation_play", { name: "shoot" });
					}
				},
			})
			// Shoot 2. Really similar to shoot 1.
			// Just with 1 projectile so even simpler.
			fsm.add("shoot2", {
				enter: function() {
					// Anim.
					self.face_player();
					self.publish("animation_xscale", self.dir);
					self.publish("animation_play", { name: "shoot_charge" });
					// Locals.
					self.startTime = CURRENT_FRAME;
					self.hasShot = false;
					// Charge sound, store because we will delete it later.
					self.chargeSound = WORLD.play_sound("powerup");
				},
				step: function() {
					// Charge particles.
					if (CURRENT_FRAME - self.startTime < 50 &&
						CURRENT_FRAME mod 4 == 0
					) {
						var partc = new ArmorCapsuleParticle(
							self.get_instance().x + random_range(-16, 16),
							self.get_instance().y + random_range(8, 14), self.dir
						);
						partc.velocity.y = -4;
						WORLD.spawn_particle(partc);
					}
					// Aim before launch.
					if (CURRENT_FRAME - self.startTime < 35) {
						self.face_player();
						self.publish("animation_xscale", self.dir);
					}
					// Shot if on frame.
					// The charge time here is half of what is on X yellow charge.
					if (!self.hasShot && CURRENT_FRAME - self.startTime >= 52) {
						// Play shoot animation.
						self.publish("animation_play", { name: "shoot2" });
						// Proj and sound.
						PROJECTILES.create_projectile(
							self.get_instance().x + (14 * self.dir),
							self.get_instance().y - 4,
							self.dir, TestBossBuster2,
							get(ComponentWeaponUse), ["enemy"], 0
						);
						// Stop charge and play shoot.
						WORLD.stop_sound(self.chargeSound);
						WORLD.play_sound("super_charge_shoot");
						// Flags.
						self.hasShot = true;
					}
					// Exit if animation ended.
					if (CURRENT_FRAME - self.startTime >= 62) {
						self.fsm.change("idle");
					} 
				},
				leave: function() {
					// In case we exit the state early.
					WORLD.stop_sound(self.chargeSound);
				}
			})
			// Dash start state.
			// Slower than the actual dash.
			.add("dash_start", {
				enter: function() {
					// Face enemy and anim
					self.face_player();
					self.publish("animation_xscale", self.dir);
					self.publish("animation_play", { name: "dash_start" });
					// Set speed.
					self.get(ComponentPhysics).set_hspd(0.5 * self.dir)
					// Play dash sound.
					WORLD.play_sound("dash");
					// Local variables.
					self.startTime = CURRENT_FRAME;
				},
				step: function() {
					// Change to dash on animation end.
					if (CURRENT_FRAME - self.startTime >= 3) {
						self.fsm.change("dash");
					}
				},
				leave: function() {
					// Set speed to 0.
					self.get(ComponentPhysics).set_hspd(0)
				}
			})
			// Main dash state.
			.add("dash", {
				enter: function() {
					// Anim and stuff.
					self.publish("animation_play", { name: "dash" });
					self.get(ComponentPhysics).set_hspd(3.75 * self.dir)
					self.startTime = CURRENT_FRAME;
				},
				step: function() {
					// Exit once 45 frames passed.
					if (CURRENT_FRAME - self.startTime >= 45) {
						self.fsm.change("dash_end");
						return;
					}
					// Smoke effect.
					if (CURRENT_FRAME mod 4 == 0) {
						var inst = self.get_instance();
						WORLD.spawn_particle(
							new DustParticle(
								inst.x - 16 * self.dir,
								inst.y + 8, self.dir
							)
						);
					}
				},
				leave: function() {
					// Speed to 0 on leave.
					self.get(ComponentPhysics).set_hspd(0)
				}
			})
			// Dash end, used to have PSX dash ending.
			.add("dash_end", {
				enter: function() {
					// Anim and stuff.
					self.publish("animation_play", { name: "dash_end" });
					self.get(ComponentPhysics).set_hspd(1.25 * self.dir)
					self.startTime = CURRENT_FRAME;
				},
				step: function() {
					// Exit on animation ending.
					if (CURRENT_FRAME - self.startTime >= 7) {
						self.fsm.change("idle");
					}
				},
				leave: function() {
					// Speed to 0 on leave.
					self.get(ComponentPhysics).set_hspd(0)
				}
			})
			.add("jump_start",{
				enter: function() {
					// Anim and time.
					self.face_player();
					self.publish("animation_xscale", self.dir);
					self.publish("animation_play", { name: "jump_start" });
					self.startTime = CURRENT_FRAME;
				},
				step: function() {
					// Once the anim ends we start the jump.
					if (CURRENT_FRAME - self.startTime >= 5) {
						// Face the player.
						self.face_player();
						self.publish("animation_xscale", self.dir);
						// Set jump speed to the same as X.
						self.get(ComponentPhysics).set_vspd(-5.25);
						// Get player and self.
						var actor = self.get_instance();
						var nearPlayer = instance_nearest(actor.x, actor.y, obj_player);
						// Get distance between the 2.
						var posDiff = nearPlayer.x - actor.x;
						// Use that distance to aim for the player positon.
						self.get(ComponentPhysics).set_hspd(posDiff / 38.0);
						// Jump very up if the enemy is on a wall and above you.
						if (abs(posDiff) <= 64 && nearPlayer.y - actor.y <= -80 &&
							self.check_player_wallclimb(self)
						) {
							self.get(ComponentPhysics).set_vspd(-9);
						}
						// Play jump sound.
						WORLD.play_sound("jump");
						// Change to the actual jump state.
						self.fsm.change("jump");
					}
				},
			})
			// Main jump, mostly empty.
			.add("jump",{
				enter: function() {
					self.publish("animation_play", { name: "jump" });
				}
			})
			// Fall, empty aside form animations.
			.add("fall",{
				enter: function() {
					//log("IX Fall");
					self.publish("animation_play", { name: "fall" });
				},
			})
			// Landing, usually reached when falling.
			// See the transitions for the code use to reach this state.
			.add("land",{
				enter: function() {
					// Anim and time.
					self.publish("animation_play", { name: "land" });
					self.get(ComponentPhysics).set_hspd(0);
					self.startTime = CURRENT_FRAME;
				},
				step: function() {
					// Go to idle on animation end.
					if (CURRENT_FRAME - self.startTime >= 5) {
						self.fsm.change("idle");
					}
				},
			})
			// Giga attack at low HP.
			.add("giga_charge", {
				enter: function() {
					// Anim.
					self.face_player();
					self.publish("animation_xscale", self.dir);
					self.publish("animation_play", { name: "giga_charge" });
					// Locals.
					self.startTime = CURRENT_FRAME;
					// Charge sound, store because we will delete it later.
					self.chargeSound = WORLD.play_sound("wsponge_charge");
				},
				step: function() {
					// Charge particles.
					var partc = new ArmorCapsuleParticle(
						self.get_instance().x + random_range(-16, 16),
						self.get_instance().y + random_range(8, 14), self.dir
					);
					partc.velocity.y = -4;
					WORLD.spawn_particle(partc);
					if (CURRENT_FRAME - self.startTime >= 108) {
						self.fsm.change("giga_dash");
					} 
				},
				leave: function() {
					// Stop charge sound on exit.
					WORLD.stop_sound(self.chargeSound);
				}
			})
			.add("giga_dash", {
				enter: function(){
					// Animation.
					self.face_player();
					self.publish("animation_xscale", self.dir);
					self.publish("animation_play", { name: "giga_dash" });
					// Get player and self.
					var actor = self.get_instance();
					var nearPlayer = instance_nearest(actor.x, actor.y, obj_player);
					// Get distance between the 2.
					// We use the formula of uniform rectilar motion here.
					// Hope you paid attention in high school.
					// First we got the X and Y distance.
					var distX = abs(nearPlayer.x - actor.x);
					var distY = nearPlayer.y - actor.y;
					// The we use the formula v = d/t to calculate v that would be out y speed.
					var speedX = 9;
					var speedY = 9;
					if (distX != 0) {
						speedY = speedX * (distY / distX);
					}
					// And limit the Y speed if is too high.
					if (abs(speedY) > 32) {
						speedY = 32 * sign(speedY);
					}
					// Apply the final speed.
					self.get(ComponentPhysics).set_vspd(speedY);
					self.get(ComponentPhysics).set_hspd(speedX * self.dir);
					// Disable gravity and add iframes.
					self.get(ComponentPhysics).set_grav(new Vec2(0, 0));
					self.get(ComponentDamageable).dmg_invincible = true;
					// Play sound.
					WORLD.play_sound("nova_stike_x6");
					WORLD.play_sound("shoot_3");
					// Increase melee damage.			
					self.contact_damage = 4;
				},
				step: function() {
					// Giga end near a wall.
					var localPhysics = self.get_instance().components.get(ComponentPhysics);
					if (localPhysics.check_place_meeting(
						self.get_instance().x + self.dir * 8,
						self.get_instance().y - 2,
						obj_square_16
					)) {
						// Add camera shake.
						var cam = instance_nearest(0, 0, obj_camera);
						cam.components.get(ComponentCamera).shake_intensity = 4;
						// Set gravity to normal and bounce of the wall.
						self.get(ComponentPhysics).set_grav(new Vec2(0, 0.25));
						self.get(ComponentPhysics).set_vspd(-2 * self.dir)
						self.get(ComponentPhysics).set_hspd(-4)					
						WORLD.play_sound("explosion");
						self.fsm.change("jump");
					}
				},
				leave: function() {
					self.contact_damage = 2;
					self.get(ComponentPhysics).set_grav(new Vec2(0, 0.25));
					self.get(ComponentDamageable).dmg_invincible = false;
				}
			})
			// ------------------------------
			// Transitions.
			// These allow to share code between multiple states.
			// ------------------------------
			// Dash end when near a wall.
			.add_transition("t_transition", "dash", "dash_end", function() {
				var localPhysics = self.get_instance().components.get(ComponentPhysics);
				return (localPhysics.check_place_meeting(
					self.get_instance().x + self.dir * 32,
					self.get_instance().y - 2,
					obj_square_16
				))
			})
			// Go from air to land.
			.add_transition("t_transition", ["jump", "fall"], "land", function() {
				return (
					self.get(ComponentPhysics).get_vspd() >= 0 &&
					self.get_instance().components.get(ComponentPhysics).is_on_floor(2)
				);
			})
			// To from land to air.
			.add_transition("t_transition", ["jump", "dash_end", "dash"], "fall", function() {
				return (
					self.get(ComponentPhysics).get_vspd() >= 0 &&
					!self.get_instance().components.get(ComponentPhysics).is_on_floor(2)
				);
			})
		}
	}
}

// Buster projectile.
// It takes code from the "xBuster12Data" class.
function TestBossBuster() : xBuster12Data() constructor {
	// Anim and damage.
	self.animation = "hermes_shot_1";
	self.damage = 2;
}

// Charge buster projectile.
function TestBossBuster2() : xBuster12Data() constructor {
	// Anim and damage.
	self.animation = "hermes_shot_3";
	self.damage = 3;
	// Do not destroy on shoot.
	self.true_piercing = true;
	// Hitboxes.
	self.hitbox_scale = new Vec2(32, 32);
	self.hitbox_offset = new Vec2(0,0);
}
