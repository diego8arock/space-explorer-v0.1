extends Node2D

export var cargo_ship: PackedScene
export var attack_ship: PackedScene
export var player: PackedScene
export var ui: PackedScene

var n_cargo_ship
var n_attack_ships = []
var n_player
var n_ui


func _ready() -> void:
		
	n_ui = ui.instance()
	add_child(n_ui)
	
	n_player = player.instance()
	add_child(n_player)
	
	n_cargo_ship = cargo_ship.instance()
	n_cargo_ship.end = Position2D.new()
	n_cargo_ship.end.global_position = Vector2.ZERO
	add_child(n_cargo_ship)
	
	for i in range(2):
		var new_attack_ship = attack_ship.instance()
		n_attack_ships.append(new_attack_ship)
		add_child(new_attack_ship)
	
	
