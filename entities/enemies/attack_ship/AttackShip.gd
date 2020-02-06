extends KinematicBody2D

#Export
export var debug: bool = false
#OnReady
onready var n_muzzle_left = $Muzzles/MuzzleLeft
onready var n_muzzle_right = $Muzzles/MuzzleRight
onready var n_health = $Health
onready var n_fire_rate = $FireRate
onready var n_collider = $CollisionPolygon2D
onready var n_aim_target = $AimTarget
#Members
var m_attack_groups = [Groups.PLAYER, Groups.ALLY]
var m_damage = 10.0

signal died(object)

func _ready() -> void:
	
	Debug.add(name, debug)
	add_to_group(Groups.ENEMY)	
	n_muzzle_left.set_attack_groups(m_attack_groups)
	n_muzzle_left.set_damage(m_damage)
	n_muzzle_right.set_attack_groups(m_attack_groups)
	n_muzzle_right.set_damage(m_damage)
	n_aim_target.target_not_detected()
	n_health.set_health(1000)
		
func take_damage(damage: float) -> void:
	
	Debug.do(name, "damage", damage)
	n_health.take_damage(damage)
	
func died() -> void:
	
	Debug.do(name, "died", "called")
	Functions.set_object_ready_for_queue_free(self, [n_collider], [n_fire_rate], "died")
	
func safe_delete() -> void:
	
	Debug.do(name, "safe_delete", "called")
	call_deferred("free")
	
func taget_detected() -> void:
	
	n_aim_target.taget_detected()
	
func target_not_detected() -> void:
	
	n_aim_target.target_not_detected()
	
func target_aimed() -> void:
	 
	n_aim_target.target_aimed()

func _on_FireRate_timeout() -> void:
	
	n_muzzle_left.shoot()
	n_muzzle_right.shoot()

func _on_SelectArea_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	
	if event is InputEventScreenTouch:
		Events.emit_signal("target_selected", self)
		Debug.do(name, "_on_SelectArea_input_event", "touch")
		



