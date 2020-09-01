extends Node2D

const SERVERIP = "127.0.0.1"
const PORT = 3030
var client
var peerClient 
var lastConnectionStatus = null
var id
func _physics_process(delta):
	var connectionStatus = peerClient.get_connection_status()
	if lastConnectionStatus != connectionStatus:
		print(connectionStatus)
		lastConnectionStatus = connectionStatus

func _ready():
	peerClient = NetworkedMultiplayerENet.new()
	peerClient.connect("connection_succeeded", self, "_on_client_connected")
	peerClient.connect("server_disconnected", self, "_on_server_disconnected")
	peerClient.connect("connection_succeeded", self, "_on_client_connecting")
	peerClient.connect("connection_failed", self, "_on_client_connectiion_failed")
	
func _on_server_disconnected():
	print("Server Disconnected...")
func _on_client_connecting():
	print("Establish Connection...")
func _on_client_connectiion_failed():
	print("Failed to Connect...")
func _on_client_connected():
	print("Connected....")
	var world = load("res://game/World.tscn").instance()
	get_node("/root").add_child(world)
	var my_player = preload("res://game/Player.tscn").instance()
	my_player.set_name(str(id))
	my_player.set_network_master(id)
	get_node("/root/World").add_child(my_player)

func connect_to_server():
	print("trying to connect")
	peerClient.create_client(SERVERIP, PORT)
	
	get_tree().network_peer = peerClient
	id = get_tree().get_network_unique_id()
	client  = load("res://networking/RemoteClient.tscn").instance()
	
	client.set_name(str(id))
	client.set_id(id)
	print('InstanceId: ' + str(id))
	
	get_tree().get_root().call_deferred("add_child", client)


func _process(delta):
	if Input.is_key_pressed(KEY_C):
		if peerClient.get_connection_status() == 0:
			connect_to_server()
	if Input.is_key_pressed(KEY_R):
		if get_tree().network_peer != null:
			client.emitRPCSignal()
	
	

