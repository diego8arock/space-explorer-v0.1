extends Node2D

onready var followers = $Followers

func get_leader_position() -> Vector2:
	
	return global_position
	
	
func get_follower_position() -> Array:
	
	var positions = []
	for f in followers.get_children():
		positions.append(f.global_position)
	return positions

		

