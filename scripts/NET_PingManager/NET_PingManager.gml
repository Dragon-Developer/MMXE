/**
 * The PingManager is responsible for managing ping values and calculating 
 * dynamic input delay based on the average ping.
 * It stores ping history and uses it to determine an appropriate delay for input actions.
 */
function PingManager() constructor {
    // Minimum delay in frames for input actions
    self.__min_input_delay = 1;

    // Maximum delay in frames for input actions
    self.__max_input_delay = 15;

    // Threshold ping value after which maximum delay is applied
    self.__ping_threshold = 166;  

    // List to store received ping values
    self.__ping_history = [];     

    // Maximum number of pings to store in the history for delay calculation
    self.__max_ping_history = 10; 

	/**
	 * Calculates the dynamic input delay based on the average ping in the history.
	 * The delay is mapped between the minimum and maximum delay based on the average ping.
	 * 
	 * @returns {number} The calculated dynamic input delay in milliseconds.
	 */
	static calculate_dynamic_delay = function() {
	    // If there are no pings, return the minimum delay in frames
	    if (array_length(self.__ping_history) == 0) {
	        return self.__min_input_delay;
	    }

	    // Calculate the median ping (in milliseconds)
		var _base_ping = array_median(self.__ping_history);
		
	    // Map the average ping to a dynamic delay in frames
	    var _dynamic_delay_in_frames = lerp(self.__min_input_delay, self.__max_input_delay, (_base_ping / self.__ping_threshold));

	    // Ensure the delay is within the acceptable range (min and max delay in frames)
		var _result = clamp(_dynamic_delay_in_frames, self.__min_input_delay, self.__max_input_delay);
	    return floor(_result);
	};

	/**
	 * Handles the receipt of a new ping value, storing it in the ping history.
	 * If the history exceeds the maximum allowed size, the oldest ping is removed.
	 * 
	 * @param {number} ping_value The new ping value to be added to the history.
	 */
	static on_ping_received = function(_ping_value) {
	    // Store the new ping value in the history
	    array_push(self.__ping_history, _ping_value);

	    // Limit the number of pings stored in the history
	    if (array_length(self.__ping_history) > self.__max_ping_history) {
	        // Remove the oldest ping value
	        array_delete(self.__ping_history, 0, 1);  
	    }
	};
}