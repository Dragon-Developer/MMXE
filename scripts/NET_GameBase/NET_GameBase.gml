/**
 * Serves as the base class for networked game instances, managing input, game loops, events, and player synchronization.
 */
function NET_GameBase() constructor {
	self.inputs = new NET_InputManager();
	self.game_loop = new NET_GameLoopBase();
	self.__current_frame = 0;
	self.__started = false;
	self.__local_players = [];
	self.__events = {};
	self.__event_listeners = {};
	self.__input_delay = 0;
	/**
     * Sets the game loop instance.
     * @param {Struct.NET_GameLoopBase} game - The game loop to assign.
     */
	static set_game_loop = function(_game) {
		self.game_loop = _game;
		self.game_loop.parent = self;
	}
	/**
     * Sets the input manager instance.
     * @param {Struct.NET_InputManager} input - The input manager to assign.
     */
	static set_input_manager = function(_input) {
		self.inputs = _input;	
	}
	/**
     * Adds local players to the game.
     * @param {array} players - The players to add.
     */
	static add_local_players = function(_players) {
		self.__local_players = array_union(self.__local_players, _players);	
	}
	/**
     * Removes specified local players from the game.
     * @param {array} players - The players to remove.
     */
	static remove_local_players = function(_players) {
		self.__local_players = array_filter(self.__local_players, 
			method({ players: _players }, function(_value) {
				return array_get_index(players, _value) == -1
			})
		);
	}
	/**
	 * Adds a listener for a specific event.
	 * If the listener is already added for the event, it will not be added again.
	 * @param {string} _event - The name of the event to listen for.
	 * @param {function} _listener - The function to be called when the event is triggered.
	 */
	static add_event_listener = function(_event, _listener) {
	    // Initialize event listeners if not already initialized
	    self.__event_listeners[$ _event] ??= [];
    
	    // Check if listener is already added
	    if (array_get_index(self.__event_listeners[$ _event], _listener) != -1) return;
    
	    // Add the listener for the event
	    array_push(self.__event_listeners[$ _event], _listener);
		return self;
	}
	/**
	 * Triggers a specific event and calls all registered listeners for that event.
	 * @param {string} event - The name of the event to trigger.
	 */
	static trigger_event = function(_event, _args = undefined) {
	    // Check if there are listeners for the event
	    if (!struct_exists(self.__event_listeners, _event)) return;
    
	    // Loop through the listeners and invoke each one
	    for (var _i = 0, _len = array_length(self.__event_listeners[$ _event]); _i < _len; _i++) {
	        var _listener = self.__event_listeners[$ _event][_i];
	        _listener (_args);
	    }
		return self;
	}
	/**
     * Adds inputs for all local players for a given frame.
     * @param {number} frame - The frame to associate the inputs with.
     * @returns {array} The collected inputs for the frame.
     */
	static add_local_inputs = function(_frame) {
		var _result = [];
		for (var _i = 0, _len = array_length(self.__local_players); _i < _len; _i++) {
			var _player = self.__local_players[_i];
			var _input = self.inputs.getLocal(_player);
			self.add_input(_frame, _player, _input);
			array_push(_result, _input);
		};
		return _result;
	}
	/**
     * Retrieves input for a given player at the current frame.
     * @param {real} player_index - The index of the player.
     * @returns {any} The input data.
     */
	static get_input = function(_player_index) {
		return self.inputs.getInput(self.__current_frame, _player_index);	
	}
	/**
     * Adds input data for a specific player at a given frame.
     * @param {real} frame - The frame number.
     * @param {real} player_index - The player index.
     * @param {any} _input - The input data.
     */
	static add_input = function(_frame, _player_index, _input) {
		return self.inputs.addInput(_frame, _player_index, _input);
	}
	/**
     * Executes the current frame's game logic.
     */
	static run_current_frame = function() {
		self.game_loop.step();
	}	
	/**
     * Advances the game by processing inputs and executing the game loop for the current frame.
     */
	static step = function() {
		if (!self.__started) return;
		self.add_local_inputs(self.__current_frame);
		self.run_current_frame();
		self.__current_frame++;
	}
	/**
     * Draws GUI elements using the game loop.
     */
	static draw_gui = function() {
		if (!self.__started) return;
		self.game_loop.draw_gui();
	}
	/**
     * Starts the game, registering it with the wrapper.
     */
	static start = function() {
		self.__started = true;	
		NET_GameWrapper.add(self);
	}
}