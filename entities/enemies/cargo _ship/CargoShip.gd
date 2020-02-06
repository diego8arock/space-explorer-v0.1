extends KinematicBody2D

onready var guns = $Guns
onready var health = $Health
onready var steering = $Steering

export var start_path: NodePath
export var end_path: NodePath
var start: Position2D
var end: Position2D
var velocity: Vector2
var attack_range = 400.0

func _ready() -> void:
	
	Debug.add(name, true)
	add_to_group(Groups.ENEMY)
	add_to_group(Groups.LEADER)
	start = get_node(start_path)
	end = get_node(end_path)
	global_position = start.global_position
	
func _physics_process(delta: float) -> void:
	
	velocity = steering.arrive(		
		velocity, 
		end.global_position, 
		global_position,
		200)
	
	Debug.do(name,"velocity", velocity)
	move_and_slide(velocity)
	global_rotation = steering.rotate_to(velocity, global_rotation, delta)
	

