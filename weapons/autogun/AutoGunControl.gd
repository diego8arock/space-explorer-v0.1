extends Node2D

#Export
enum CHARACTER { PLAYER, ENEMY, ALLY }
export (CHARACTER) var character = CHARACTER.PLAYER
export var bullet: PackedScene

var m_attack_range: float setget set_attack_range
onready var attack_range_collision = $AttackRange/CollisionShape2D

func _ready() -> void:
	
	$Pivot.set_character(character)
	$Pivot.set_bullet(bullet)

func set_attack_range(attack_range: float) -> void:
	
	m_attack_range = attack_range
	attack_range_collision.shape.radius = m_attack_range
