extends KinematicBody2D

export var path_target: NodePath
var target
onready var steering = $Steering
var velocity: Vector2  = Vector2.ZERO
var follow_distance = 10.0
var separtion_radius = 110.0
var max_separation = 200.0
var max_velocity_speed = 180.0
var crowd = []
var rotation_speed: float = 10.0
var max_force: float = 10.0
var mass: float = 1.0

func _ready() -> void:
	
	target = get_node(path_target)
	crowd = get_tree().get_nodes_in_group("escorts")

func _physics_process(delta: float) -> void:
	
	#velocity = steering.arrive(velocity, get_global_mouse_position(), global_position, 200.0, 5.0, 2.0)
	velocity = steering.follow(
	velocity, 
	target.velocity, 
	target.global_position, 
	global_position, 
	crowd, 
	self, 
	follow_distance,
	separtion_radius, 
	max_separation, 
	max_velocity_speed,
	max_force,
	mass)
	move_and_slide(velocity)
	global_rotation = steering.rotate_to(velocity, global_rotation, delta)
