extends KinematicBody2D

export var debug = false

onready var auto_gun_control = $AutoGunPlayer
onready var auto_gun = $AutoGunPlayer/Pivot
onready var health = $Health
onready var stats = $Stats

var max_speed = 400
var min_speed = 100
var aceleration = 10.0
var breaking = 5.0
var speed: float = 0
var m_velocity: Vector2 setget , get_velocity
var rotation_speed = 15.0
var attack_range = 400.0
var fire_rate = 0.3
var spread_range = 2.0
var moving = false

signal player_global_position(g_position)

func _ready() -> void:
	
	Debug.add(name, debug)
	add_to_group(Groups.PLAYER)
	auto_gun.set_attack_groups([Groups.ENEMY])
	auto_gun.set_damage(stats.max_damage)
	auto_gun_control.set_attack_range(stats.max_attack_rage)
	auto_gun.set_fire_rate(stats.max_fire_rate)
	auto_gun.set_spread_range(stats.max_accuarcy)
	health.set_health(stats.max_health)
	Events.connect("joystick_moved", self, "on_Event_joystick_moved")
	Events.connect("joystick_stopped", self, "on_Event_joystick_stopped")
	Events.connect("target_selected", self, "on_Event_target_selected")

func _physics_process(delta: float) -> void:
	
	Debug.do(name, "speed", speed)
	if moving:
		speed += stats.max_acceleration if speed < stats.max_speed else 0
	else:
		speed -= (stats.max_acceleration / 2) if speed > (stats.max_speed * 0.4) else 0
	
	move_and_slide(m_velocity * speed)
	var current_direction = Vector2.RIGHT.rotated(global_rotation)
	global_rotation = current_direction.normalized().slerp(m_velocity.normalized(), stats.max_turning_speed * delta).angle()
	Events.emit_signal("player_global_values", global_position, global_rotation)
		
func on_Event_joystick_moved(value) -> void:
	
	moving = true
	m_velocity = m_velocity.normalized().linear_interpolate(value.normalized(), 0.25)
	Debug.do(name, "velocity", m_velocity)
	
func on_Event_joystick_stopped() -> void:
	
	moving = false
	
func on_Event_target_selected(body) -> void:
	
	auto_gun.force_set_target(body)
	
func get_velocity() -> Vector2:
	
	return m_velocity * speed
	
func safe_delete() -> void:
	pass
	
func died() -> void:
	pass
