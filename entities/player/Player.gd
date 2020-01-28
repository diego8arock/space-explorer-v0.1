extends KinematicBody2D

onready var auto_gun = $AutoGun/Pivot

var speed: float = 100
var velocity: Vector2
var rotation_speed = 15.0

func _ready() -> void:
	
	Debug.add(name, true)
	add_to_group(Groups.PLAYER)
	auto_gun.set_attack_groups([Groups.ENEMY])
	Events.connect("joystick_moved", self, "move_player")

func _physics_process(delta: float) -> void:
	
	move_and_slide(velocity * speed)
	var current_direction = Vector2.RIGHT.rotated(global_rotation)
	global_rotation = current_direction.normalized().slerp(velocity.normalized(), rotation_speed * delta).angle()
		
func move_player(value) -> void:
	
	velocity = velocity.normalized().linear_interpolate(value.normalized(), 0.25)
	Debug.do(name, "velocity", velocity)