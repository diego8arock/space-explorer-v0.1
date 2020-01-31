extends KinematicBody2D

export var speed : float = 20.0

onready var n_steering = $Steering
onready var n_homing_timer = $HomingTimer

var m_velocity = Vector2.ZERO
var m_is_homing = false

var em_target setget set_target
var em_attack_groups = [] setget set_attack_groups
var em_damage: float setget set_damage

func _physics_process(delta: float) -> void:
	
	if m_is_homing:
		m_velocity = n_steering.seek(m_velocity, em_target.global_position, global_position, speed)
	#Avoids slowing down in case of homing timer reaches 0
	m_velocity = m_velocity.normalized() * speed
	var collision = move_and_collide(m_velocity)
	global_rotation = n_steering.rotate_to(m_velocity, global_rotation, delta)
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
	m_velocity = p_rotation * speed

func _on_VisibilityNotifier2D_screen_exited() -> void:
	
	destroy_bullet()

func _on_TimeToLive_timeout() -> void:
	
	destroy_bullet()
	
func _on_HomingTimer_timeout() -> void:
	
	m_is_homing = false
	
	
func on_Target_died() -> void:
	
	m_is_homing = false

func destroy_bullet() -> void:
	
	visible = false
	queue_free()

func set_damage(damage: float) -> void:
	
	em_damage = damage

func set_attack_groups(attack_groups = []) -> void:
	
	em_attack_groups = attack_groups
	
func set_target(target) -> void:
	
	em_target = target
	if not em_target.is_connected("died", self, "on_Target_died"):	
		em_target.connect("died", self, "on_Target_died")
	m_is_homing = true


