extends Node2D


onready var zone = $CombatZone
onready var enemies = $EnemyContainer

export var debug = false
export var layers = 4
export var radius = 500
export var enemy_numbers = 3

func _ready() -> void:
	
	zone.debug = debug
	zone.create_targets(layers, radius)
	enemies.debug = debug
	enemies.create_enemies(enemy_numbers, zone)
