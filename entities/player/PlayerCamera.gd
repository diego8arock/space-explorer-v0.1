extends Camera2D

func _process(delta: float) -> void:
	
	Events.emit_signal("player_camera_moving", global_position)
