extends Node2D

enum CHARACTER { PLAYER, ENEMY, ALLY }
export (CHARACTER) var character = CHARACTER.PLAYER

var m_attack_range: float setget set_attack_range
onready var attack_range_collision = $AttackRange/CollisionShape2D

func _ready() -> void:
	
	$Pivot.set_character(character)

func set_attack_range(attack_range: float) -> void:
	
	m_attack_range = attack_range
	attack_range_collision.shape.radius = m_attack_range
