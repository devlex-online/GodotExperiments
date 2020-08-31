extends Node2D


const PORT = 3030
const MAX_PLAYERS = 5

var connected_clients = []
var server



func _ready():
	get_tree().connect("network_peer_connected", self, "_on_client_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_client_disconnected")
	server = NetworkedMultiplayerENet.new	()
	server.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = server
	
func _on_client_connected(id):
	print('Client ' + str(id) + ' connected to Server')
	var client = load("res://RemoteClient.tscn").instance()
	
	client.set_name(str(id))
	client.set_id(id)
	client.connect("test_rpc_call_signal", self, "_on_client_test_rpc_call")
	
	get_tree().get_root().add_child(client)
	
	connected_clients.append({"id": id, "client": client})

func _on_client_disconnected(id):
	print('Client ' + str(id) + ' disconnected')
	var remove = null
	for i in connected_clients.size():
		if connected_clients[i].id == id:
			remove = i
			break
	if remove != null:
		connected_clients.remove(remove)
	var node = get_tree().get_root().get_node(str(id))
	node.queue_free()

func _on_client_test_rpc_call(client):
	print("TestRPCCall: " + str(client.my_id))
	
	
