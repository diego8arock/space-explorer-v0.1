extends KinematicBody2D

onready var guns = $Guns
onready var health = $Health
onready var steering = $Steering
onready var n_stats = $Stats
onready var n_aim_target = $AimTarget
onready var n_collider = $CollisionPolygon2D

var start: Position2D
var end: Position2D
var velocity: Vector2
var attack_range = 400.0

signal died(object)

func _ready() -> void:
	
	Debug.add(name, true)
	add_to_group(Groups.ENEMY)
	add_to_group(Groups.LEADER)
	n_aim_target.target_not_detected()
	health.set_health(n_stats.health)
	
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

func died() -> void:
	
	Debug.do(name, "died", "called")
	Functions.set_object_ready_for_queue_free(self, [n_collider], [], "died")
	
func safe_delete() -> void:
	
	Debug.do(name, "safe_delete", "called")
	call_deferred("free")	
	
func target_detected() -> void:
	
	n_aim_target.target_detected()
	
func target_not_detected() -> void:
	
	n_aim_target.target_not_detected()
	
func target_aimed() -> void:
	 
	n_aim_target.target_aimed()
