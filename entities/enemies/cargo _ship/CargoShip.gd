extends KinematicBody2D

onready var guns = $Guns
onready var health = $Health
onready var steering = $Steering

var attack_range = 400.0

func _ready() -> void:
	
	add_to_group(Groups.ENEMY)

