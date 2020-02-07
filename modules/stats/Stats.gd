extends Node

export var attributes: Resource
export var movement: Resource

#attributes
var health: float 
var damage: float 

#movement
var max_speed: float
var mass: float
var max_force: float 
var rotation_speed: float
var arrival_distance : float
var follow_distance: float
var separation_radius : float
var max_separation: float

func _ready() -> void:
	
	assert(attributes)
	assert(movement)
	
	health = attributes.health
	damage = attributes.damage
	
	max_speed = movement.max_speed
	mass = movement.mass
	max_force  = movement.max_force
	rotation_speed = movement.rotation_speed
	arrival_distance  = movement.arrival_distance
	follow_distance = movement.follow_distance
	separation_radius  = movement.separation_radius
	max_separation = movement.max_separation	

