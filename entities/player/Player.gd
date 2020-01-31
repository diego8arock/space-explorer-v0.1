extends KinematicBody2D

export var debug = false

onready var auto_gun_control = $AutoGun
onready var auto_gun = $AutoGun/Pivot
onready var health = $Health

var max_speed = 400
var min_speed = 100
var aceleration = 10.0
var breaking = 5.0
var speed: float = 0
var velocity: Vector2
var rotation_speed = 15.0
var attack_range = 400.0
var fire_rate = 0.3
var spread_range = 2.0
var moving = false

func _ready() -> void:
	
	Debug.add(name, debug)
	add_to_group(Groups.PLAYER)
	auto_gun.set_attack_groups([Groups.ENEMY])
	auto_gun.set_damage(5)
	auto_gun_control.set_attack_range(attack_range)
	auto_gun.set_fire_rate(fire_rate)
	auto_gun.set_spread_range(spread_range)
	health.set_health(10000)
	Events.connect("joystick_moved", self, "move_player")
	Events.connect("joystick_stopped", self, "stop_player")
	Events.connect("target_selected", self, "target_selected")

func _physics_process(delta: float) -> void:
	
	Debug.do(name, "speed", speed)
	if moving:
		speed += aceleration if speed < max_speed else 0
	else:
		speed -= breaking if speed > min_speed else 0
	
	move_and_slide(velocity * speed)
	var current_direction = Vector2.RIGHT.rotated(global_rotation)
	global_rotation = current_direction.normalized().slerp(velocity.normalized(), rotation_speed * delta).angle()
		
func move_player(value) -> void:
	
	moving = true
	velocity = velocity.normalized().linear_interpolate(value.normalized(), 0.25)
	Debug.do(name, "velocity", velocity)
	
func stop_player() -> void:
	
	moving = false
	
func target_selected(body) -> void:
	
	auto_gun.force_set_target(body)
	
func safe_delete() -> void:
	pass
	
func died() -> void:
	pass
