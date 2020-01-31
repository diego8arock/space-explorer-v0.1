extends Node

#Constants
const DEFAULT_MAX_HEALTH: float = 10.0
const DEFAULT_MIN_HEALTH: float = 0.0
#OnReady
onready var safe_delete = $SafeDeleteTimer
#Events
signal died()
#External Members
var em_health: float setget set_health, get_health

func _ready() -> void:
	
	em_health = DEFAULT_MAX_HEALTH
	
	if not owner.has_method("safe_delete"):
		push_warning("owner %s as no safe_delete method to connect" % owner.name)
		
	if not owner.has_method("died"):
		push_warning("owner %s as no died method to connect" % owner.name)
		
	connect("died", owner, "died")
	safe_delete.connect("timeout", owner, "safe_delete")

func take_damage(damage: float) -> void:
	
	em_health -= damage	
	check_health()

func set_health(health) -> void:
	
	em_health = health
	
func get_health() -> float:
	
	return em_health
	
func check_health() -> void:
	
	if em_health <= DEFAULT_MIN_HEALTH:
		emit_signal("died")
		safe_delete.start()
