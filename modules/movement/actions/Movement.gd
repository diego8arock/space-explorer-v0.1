extends Node

var follow_leader
var arrive_at_target
var pursuit_target

func _ready() -> void:
	
	follow_leader = get_node_if_exists("FollowLeader")
	arrive_at_target = get_node_if_exists("ArriveAtTarget")
	pursuit_target = get_node_if_exists("PursuitTarget")		
		
func get_node_if_exists(node_name) -> Node:
	
	if has_node(node_name):
		return get_node(node_name)
	return null
	
	
	
