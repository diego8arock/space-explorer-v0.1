extends Node

static func add_object_to_groups(object: Node2D, groups = []) -> void:
	
	for g in groups:
		object.add_to_group(g)
		
func get_objects_from_groups(groups = []) -> Array:
	
	var all_objects = {}
	for g in groups:
		var nodes = get_tree().get_nodes_in_group(g)
		for o in nodes:
			if all_objects.has(o):
				all_objects[o] = all_objects[o] + 1
			else:
				all_objects[o] = 1
				
	var objects = []
	for o in all_objects:
		if all_objects[o] == groups.size():
			objects.append(o)
		
	return objects
		

static func is_object_in_any_group(object: Node2D, groups = []) -> bool:
	
	for g in groups:
		if object.is_in_group(g):
			return true
	return false

static func set_object_ready_for_queue_free(object: Node2D, colliders = [], timers = [], delete_signal_name = "died") -> void:
	
	object.set_process(false)
	object.set_physics_process(false)
	object.visible = false
	for c in colliders:
		if c is CollisionObject2D or c is CollisionPolygon2D:
			c.disabled = true
	for t in timers:
		if t is Timer:
			t.stop()
	object.emit_signal(delete_signal_name, object)
	
	
