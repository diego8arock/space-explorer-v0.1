extends Node

export var stats: Resource

var max_health: float
var max_shield: float
var shield_recharge_rate: float
var shield_recharge_delay: float

var max_speed: float
var max_acceleration: float
var max_turning_speed: float

var max_damage: float
var max_attack_rage: float
var max_fire_rate: float
var max_accuarcy: float

func _ready() -> void:
	
	assert(stats)
	
	max_health = stats.max_health
	max_shield = stats.max_shield
	shield_recharge_rate = stats.shield_recharge_rate
	shield_recharge_delay = stats.shield_recharge_delay
	
	max_speed = stats.max_speed
	max_acceleration = stats.max_acceleration
	max_turning_speed = stats.max_turning_speed
	
	max_damage = stats.max_damage
	max_attack_rage = stats.max_attack_rage
	max_fire_rate = stats.max_fire_rate
	max_accuarcy = stats.max_accuarcy
