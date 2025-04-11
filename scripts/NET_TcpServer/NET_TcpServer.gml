function NET_TcpServer(_port, _max_clients = 1000) 
: NET_Server(network_socket_tcp, _port, _max_clients) constructor {
	
}
function NET_TcpServerRAW(_port, _max_clients = 1000) 
: NET_ServerRAW(network_socket_tcp, _port, _max_clients) constructor {
	
}