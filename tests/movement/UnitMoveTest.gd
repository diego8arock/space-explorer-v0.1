extends KinematicBody2D

onready var steering = $Steering
var state
var velocity = Vector2.ZERO
var speed = 100.0
var mass = 100.0
var force = 100.0
var arrival_distance = 100.0
var rotation_speed = 1.0
var m_target = null

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	if m_target:
		velocity = steering.arrive(velocity,
			m_target.global_position,
			global_position,
			speed,
			force,
			mass,
			arrival_distance)
		
	move_and_slide(velocity)
	global_rotation = steering.rotate_to(velocity, global_rotation, delta, rotation_speed)

func _on_MovementTool_speed_changed(value) -> void:
	
	speed = float(value)

func _on_MovementTool_force_changed(value) -> void:
	
	force = float(value)

func _on_MovementTool_mass_changed(value) -> void:
	
	mass = float(value)

func _on_MovementTool_option_changed(value) -> void:
	
	state = value

func _on_MovementTool_rotation_changed(value) -> void:
	
	rotation_speed = float(value)

func _on_TestMovement_target_changed(target) -> void:
	
	m_target = target
