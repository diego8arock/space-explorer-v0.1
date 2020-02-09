extends Node2D

onready var leader_start = $LeaderStart

export var cargo_ship: PackedScene
export var attack_ship: PackedScene
export var player: PackedScene
export var ui: PackedScene

var n_cargo_ship: Node2D
var n_attack_ships = []
var n_player: Node2D
var n_ui: CanvasLayer

var end_position = Vector2(-55000, -55000)

func _ready() -> void:
		
	n_ui = ui.instance()
	add_child(n_ui)
	
	Debug.insert_debug()

	n_player = player.instance()
	add_child(n_player)
	
	n_cargo_ship = cargo_ship.instance()
	n_cargo_ship.global_position = leader_start.get_leader_position()
	var n_end_position = Position2D.new()
	n_end_position.global_position = end_position
	n_cargo_ship.end = n_end_position
	add_child(n_cargo_ship)
	add_child(n_end_position)
#	var camera2d = Camera2D.new()
#	camera2d.current = true
#	n_cargo_ship.add_child(camera2d)
	
	var followers_poisition = leader_start.get_follower_position()
	
	for i in range(1):
		var new_attack_ship = attack_ship.instance()
		n_attack_ships.append(new_attack_ship)
		new_attack_ship.global_position = followers_poisition[i]
		new_attack_ship.debug = true
		add_child(new_attack_ship)
	
	
