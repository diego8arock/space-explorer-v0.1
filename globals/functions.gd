extends Node

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
	
	
