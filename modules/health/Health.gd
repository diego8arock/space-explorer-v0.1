extends Node

const DEFAULT_MAX_HEALTH: float = 10.0

var m_health: float setget set_health, get_health

func take_damage(damage: float) -> void:
	
	m_health -= damage	

func set_health(health) -> void:
	
	m_health = health
	
func get_health() -> float:
	
	return m_health