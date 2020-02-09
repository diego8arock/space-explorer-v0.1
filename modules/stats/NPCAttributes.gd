extends Node

export var attributes: Resource

#attributes
var health: float 
var damage: float 

func _ready() -> void:
	
	assert(attributes)
	
	health = attributes.health
	damage = attributes.damage
