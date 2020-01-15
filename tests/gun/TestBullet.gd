extends KinematicBody2D

export var speed : float = 20.0

var velocity = Vector2()

func _physics_process(delta: float) -> void:
	
	var collision = move_and_collide(velocity)
	if collision: 
		if collision.collider.is_in_group("targets"):
			collision.collider.take_damage()
			destroy_bullet()

func shoot(p_position: Vector2, p_rotation: Vector2):
	
	global_position = p_position
	global_rotation = p_rotation.angle()
	velocity = p_rotation * speed

func _on_VisibilityNotifier2D_screen_exited() -> void:
	
	visible = false
	destroy_bullet()

func _on_TimeToLive_timeout():
	
	destroy_bullet()

func destroy_bullet() -> void:
	
	queue_free()



