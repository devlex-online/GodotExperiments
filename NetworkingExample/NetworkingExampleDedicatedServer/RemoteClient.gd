extends Node

var my_id

signal test_rpc_call_signal

func set_id(id):
	my_id = id

remote func test_rpc_call():
	print("Client " + str(my_id) + " TestRPCCAll")
	
remote func test_rpc_call_signal():
	emit_signal("test_rpc_call_signal", self)
