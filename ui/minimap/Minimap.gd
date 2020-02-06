extends Node2D

onready var enemy_indicator:PackedScene = preload("res://ui/minimap/Indicator.tscn")
onready var player = $Player
onready var radar = $Radar
onready var enemies_container = $EnemiesContainer
onready var line = $Radar/Radius
var rotation_speed = 15.0
var velocity: Vector2
var player_global_position
var player_global_rotation
var radius
var out_of_range: float = 1000.0

var enemies = {}

func _ready() -> void:
	
	Debug.add(name, true)
	var p1: Vector2 = line.points[0]
	var p2: Vector2 = line.points[1]
	radius = p1.distance_to(p2) 
	Events.connect("player_global_values", self, "on_Player_global_values")
	Events.connect("joystick_moved", self, "move_player")
	Events.connect("joystick_stopped", self, "stop_player")

func _process(delta: float) -> void:

	get_all_enemies()
	update_enemies_position(delta)

func move_player(value) -> void:
	
	velocity = velocity.normalized().linear_interpolate(value.normalized(), 0.25)
	
func stop_player() -> void:
	pass	

func get_all_enemies() -> void:
	
	var enemies_group = get_tree().get_nodes_in_group(Groups.ENEMY)
	for e in enemies_group:
		if not enemies.has(e):
			var sprite = enemy_indicator.instance()
			enemies[e] = sprite
			e.connect("died", self, "on_Enemy_died")
			enemies_container.add_child(sprite)
	

func update_enemies_position(delta) -> void:
	
	for e in enemies:
		if e:
			var indicator = enemies[e]
			var distance = player_global_position.distance_to(e.global_position)
			var sprite = indicator.get_node("Sprite")			
			if distance <= out_of_range:
				distance = distance / 5
				sprite.position = Vector2(distance , 0)
			else:
				sprite.position = Vector2(radius , 0)
			var current_direction = Vector2.RIGHT.rotated(player_global_rotation)
			indicator.rotation = current_direction.normalized().slerp(velocity.normalized(), rotation_speed * delta).angle() 
			indicator.rotation += (player_global_position.angle_to_point(e.global_position) * -1) + deg2rad(90)
		
func on_Enemy_died(object) -> void:
	
	enemies.erase(object)
	
func on_Player_global_values(g_position, g_rotation) -> void:
	
	player_global_position = g_position
	player_global_rotation = g_rotation

	
