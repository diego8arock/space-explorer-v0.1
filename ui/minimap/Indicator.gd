extends Node2D

onready var sprite = $Sprite
onready var red_dot = preload("res://ui/minimap/assets/dotRed.png")
onready var crosshair = preload("res://ui/minimap/assets/crossair_redOutline.png")
onready var green_dot = preload("res://ui/minimap/assets/dotGreen.png")

var is_red_dot = false
var is_crosshair = false

func set_red_dot() -> void:
	
	sprite.texture = red_dot
	is_red_dot = true
	is_crosshair = false

func set_crosshair() -> void:
	
	sprite.texture = crosshair
	is_red_dot = false
	is_crosshair = true
	
func set_green_dot() -> void:	
	
	sprite.texture = green_dot
