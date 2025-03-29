function NET_WebSocketServer(_port, _max_clients = 1000) 
: NET_Server(network_socket_ws, _port, _max_clients) constructor {

}
function WebSocketServerRAW(_port, _max_clients = 1000) 
: NET_ServerRAW(network_socket_ws, _port, _max_clients) constructor {

}