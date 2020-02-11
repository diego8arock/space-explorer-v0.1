extends Node

onready var attack_ship = preload("res://entities/enemies/attack_ship/AttackShip.tscn")
var debug = false
		
func create_enemies(number:int, zone) -> void:
	
	for i in range(number):
		var attsh = attack_ship.instance()
		attsh.connect("request_random_ttm",zone,"on_AttackShip_request_random_ttm" )
		add_child(attsh)
		attsh.debug = debug
