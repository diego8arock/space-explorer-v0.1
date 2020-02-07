extends KinematicBody2D

onready var guns = $Guns
onready var health = $Health
onready var steering = $Steering
onready var n_stats = $Stats
onready var n_aim_target = $AimTarget

var start: Position2D
var end: Position2D
var velocity: Vector2
var attack_range = 400.0

func _ready() -> void:
	
	Debug.add(name, true)
	add_to_group(Groups.ENEMY)
	add_to_group(Groups.LEADER)
	n_aim_target.target_not_detected()
	
func _physics_process(delta: float) -> void:
	
	velocity = steering.arrive(		
		velocity, 
		end.global_position, 
		global_position,
		n_stats.max_speed,
		n_stats.max_force,
		n_stats.mass,
		n_stats.arrival_distance)
	
	Debug.do(name,"velocity", velocity)
	move_and_slide(velocity)
	global_rotation = steering.rotate_to(velocity, global_rotation, delta)
	
func target_detected() -> void:
	
	n_aim_target.target_detected()
	
func target_not_detected() -> void:
	
	n_aim_target.target_not_detected()
	
func target_aimed() -> void:
	 
	n_aim_target.target_aimed()
