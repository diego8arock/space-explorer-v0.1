extends Node2D

onready var aimed = $Aimed
onready var detected = $Detected

func target_not_detected() -> void:
	
	aimed.visible = false
	detected.visible = false

func target_detected() -> void:
	
	detected.visible = true
	aimed.visible = false
	
func target_aimed() -> void:
	
	detected.visible = false
	aimed.visible = true
