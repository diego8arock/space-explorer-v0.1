extends KinematicBody2D

export var speed : float = 20.0
var em_attack_groups = [] setget set_attack_groups
var velocity = Vector2()
var em_damage: float setget set_damage

func _physics_process(delta: float) -> void:
	
	var collision = move_and_collide(velocity)
	if collision: 
		var collider = collision.collider
		if Functions.is_object_in_any_group(collider, em_attack_groups) and collider.has_node(Modules.HEALTH):
			collision.collider.get_node(Modules.HEALTH).take_damage(em_damage)
		destroy_bullet()

func shoot(p_position: Vector2, p_rotation: Vector2):
	
	assert(em_attack_groups && em_attack_groups.size() > 0)
	assert(em_damage)
		
	global_position = p_position
	global_rotation = p_rotation.angle()
	velocity = p_rotation * speed

func set_damage(damage: float) -> void:
	
	em_damage = damage

func set_attack_groups(attack_groups = []) -> void:
	
	em_attack_groups = attack_groups

func _on_VisibilityNotifier2D_screen_exited() -> void:
	
	destroy_bullet()

func _on_TimeToLive_timeout() -> void:
	
	destroy_bullet()

func destroy_bullet() -> void:
	
	visible = false
	queue_free()
