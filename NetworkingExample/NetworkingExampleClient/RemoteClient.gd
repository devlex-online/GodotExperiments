extends Node


var my_id
var server_id = 1

func set_id(id):
	my_id = id
	
func emitRPCSignal():
	rpc_id(server_id, "test_rpc_call_signal")
