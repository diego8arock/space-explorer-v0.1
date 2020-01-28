extends KinematicBody2D

onready var steering = $Steering
export var path_target: NodePath
export var debug: bool = false
var target
var velocity: Vector2 = Vector2.ZERO
var rotation_speed = 3.0

func _ready() -> void:
	
	Debug.node(name, debug)
	target = get_node(path_target)

func _physics_process(delta: float) -> void:
	
	velocity = steering.arrive(velocity, get_global_mouse_position(), global_position, 200.0, 5.0, 2.0)
	var collide = move_and_slide(velocity)
	global_rotation = steering.rotate_to(velocity, global_rotation, delta, rotation_speed)
	Debug.do(name, "velocity:", velocity)
