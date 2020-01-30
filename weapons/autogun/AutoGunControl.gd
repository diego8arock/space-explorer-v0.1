extends Node2D

enum CHARACTER { PLAYER, ENEMY, ALLY }
export (CHARACTER) var character = CHARACTER.PLAYER

func _ready() -> void:
	
	$Pivot.set_character(character)

