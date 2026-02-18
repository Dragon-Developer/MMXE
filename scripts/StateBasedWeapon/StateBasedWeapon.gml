// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function StateBasedWeapon() : Weapon() constructor{
	self.term = "State Based"
}

function StateBasedData() constructor{
	self.term = "State Based"
	self.state_name = "undefined"
	
	self.init = function(_fsm){
		log("No defined states! This weapon may produce crashes!")
	}
}