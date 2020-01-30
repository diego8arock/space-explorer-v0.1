extends KinematicBody2D

#Export
export var debug: bool = false
#OnReady
onready var muzzle_left = $Muzzles/MuzzleLeft
onready var muzzle_right = $Muzzles/MuzzleRight
onready var health = $Health
onready var fire_rate = $FireRate
onready var collider = $CollisionPolygon2D
#Members
var m_attack_groups = [Groups.PLAYER, Groups.ALLY]
var m_damage = 10.0

signal died()

func _ready() -> void:
	
	Debug.add(name, debug)
	add_to_group(Groups.ENEMY)	
	muzzle_left.set_attack_groups(m_attack_groups)
	muzzle_left.set_damage(m_damage)
	muzzle_right.set_attack_groups(m_attack_groups)
	muzzle_right.set_damage(m_damage)
	
func take_damage(damage: float) -> void:
	
	Debug.do(name, "damage", damage)
	health.take_damage(damage)
	
func died() -> void:
	
	Debug.do(name, "died", "called")
	collider.disabled = true
	fire_rate.stop()
	set_process(false)
	set_physics_process(false)
	visible = false
	emit_signal("died")
	
func safe_delete() -> void:
	
	Debug.do(name, "safe_delete", "called")
	call_deferred("free")

func _on_FireRate_timeout() -> void:
	
	muzzle_left.shoot()
	muzzle_right.shoot()
