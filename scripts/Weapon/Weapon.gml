/* dark's mission statement

The system will be flexible enough when: 
	it is easy to add another similar weapon, with some different values
	it is easy to add a weapon that contains only combinations of already implemented weapon features
	it is easy to assign the weapon to an enemy/boss as well, for example
	it is easy to update this weapon properties
	it is easy to overwrite weapon values, because of a specific armor or combination, or because the entity picked up a specific item

all this without having to copy/paste specific functionality code
-----------------------------------------------------------------
it is easy to add another similar weapon, with some different values
	- inheritance with constructors. have a basic weaponData constructor that can include data on projectile stuff.
it is easy to add a weapon that contains only combinations of already implemented weapon features
	- have projectiles be a seperate constructor. I think having projectiles use the animation system and 
		being a constructor would make it easier to have inheritance. I know dark wants to have everything do one thing,
		and do that one thing very well, so i wont lump projectile data with weapon data. 
		please blame me, forte, if the weapon system becomes 10x more confusing!
it is easy to assign the weapon to an enemy/boss as well, for example
	- this should be handled in the enemy death event. unless dark and I were thinking the same idea of having enemies use the player
		shot system, which i highly doubt. i should double check though
it is easy to update this weapon properties
	- im not quite sure how i would do this. plus, what would this entail? the best and most reliable way to do this is to have weapondata
		be a parameter in the weaponslot, so if you want to swap out your default buster for the x4 plasma shot, you just change the weapondata
		of your first weaponslot. 
it is easy to overwrite weapon values, because of a specific armor or combination, or because the entity picked up a specific item
	- same as above really, swap out the weapondata of the weaponslot. changing weapon values and properties are the same thing, unless dark meant
		something else that im not catching.
*/

function Weapon() constructor{
	/*  
		weaponData is for immutable stuff, like maximum ammo capacity and the such
		this will be a parent class for projectileWeapon and MeleeWeapon, so this might not hold much\
		main reason this exists is to make storing a weapon in a weaponslot easier

		stuff to be included in base WeaponData class:
		max ammo
		cost rate
		refill rate (in frames?)
		palette index
		
	*/
	
	self.term = "undefined";
	self.title = "Undefined";
	self.data = [noone,noone,noone,noone, noone];
	self.maxAmmo = 28;
	self.cost = 1;//should this be an array?
	self.refillRate = 0;// 1/60 would be one tick every second
	self.paletteIndex = 0;
	self.charge_limit = 2;
	self.animation_append = "_shoot";//what is added to the end of the animation name. if the name of the animation is idle, remove _idle and then append
	self.lock_until_animation_end = false;//for things like gigas where you lose control. PLEASE use this sparingly, removing control from players is never a good idea
	self.weapon_palette = [
		#203080,//Blue Armor Bits
		#0040f0,
		#0080f8,
		#1858b0,//Under Armor Teal Bits
		#50a0f0,
		#78d8f0,
		#181818,//black
		#804020,//Face
		#b86048,
		#f8b080,
		#989898,//glove
		#e0e0e0,
		#f0f0f0,//eye white
		#f04010//red
	];
}

function WeaponSlot() constructor{
	/*
		WeaponSlot is for stuff that can change. it stores a reference to the WeaponData that
		the slot is actually a part of. 
		
		could we use the weapon system for enemies too? it would make things like an a-trans 
		enemy weapon copy easy. -forte
		
		hell no! that sounds so unusable! future forte is prioritizing usability, so if
		something like that were to be implemented, it would be seperate from an easier
		variation of enemies. Options, people, options!
		
		stuff included in WeaponSlot:
		current ammo
		weapon data
		
	*/
	
	self.ammo = 28;
	self.weaponData = new Weapon();//prematurely fill it with a dummy weapon data so it wont shit itself
}