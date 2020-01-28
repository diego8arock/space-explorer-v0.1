extends Node

static func is_object_in_any_group(object: Node2D, groups = []) -> bool:
	
	for g in groups:
		if object.is_in_group(g):
			return true
	return false
