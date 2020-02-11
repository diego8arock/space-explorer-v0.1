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
var active_target

var enemies = {}
var enemies_dead = []

func _ready() -> void:
	
	Debug.add(name, true)
	var p1: Vector2 = line.points[0]
	var p2: Vector2 = line.points[1]
	radius = p1.distance_to(p2) 
	Events.connect("player_global_values", self, "on_Player_global_values")
	Events.connect("joystick_moved", self, "on_Event_joystick_moved")
	Events.connect("joystick_stopped", self, "on_Event_joystick_stopped")
	Events.connect("player_auto_gun_set_target", self, "on_Player_auto_gun_set_target")
	Events.connect("player_auto_gun_target_lost", self, "on_Player_auto_gun_target_lost")

func _process(delta: float) -> void:

	get_all_enemies()
	update_enemies_position(delta)

func on_Event_joystick_moved(value) -> void:
	
	velocity = velocity.normalized().linear_interpolate(value.normalized(), 0.25)
	
func on_Event_joystick_stopped() -> void:
	pass	

func get_all_enemies() -> void:
	
	var enemies_group = get_tree().get_nodes_in_group(Groups.ENEMY)
	for e in enemies_group:
		if not enemies.has(e) and not enemies_dead.has(e):
			var sprite = enemy_indicator.instance()
			enemies[e] = sprite
			assert(e.connect("died", self, "on_Enemy_died") == 0)		
			enemies_container.add_child(sprite)
			sprite.set_red_dot()
	

func update_enemies_position(delta) -> void:
	
	for e in enemies:
		if e:
			var indicator = enemies[e]
			adjust_indicator_rotation_to_object(e, indicator, delta)
			set_enemy_sprite(e, indicator)
			
func adjust_indicator_rotation_to_object(object, indicator, delta) -> void:
	
	var distance = player_global_position.distance_to(object.global_position)
	var sprite = indicator.sprite			
	if distance <= out_of_range:
		distance = distance / 5
		sprite.position = Vector2(0, distance)
	else:
		sprite.position = Vector2(0, radius)
	var current_direction = Vector2.RIGHT.rotated(player_global_rotation)
	indicator.rotation = current_direction.normalized().slerp(velocity.normalized(), rotation_speed * delta).angle() 
	indicator.rotation -= player_global_position.angle_to_point(object.global_position)
	indicator.rotation *= -1
	sprite.global_rotation = 0	
					
func set_enemy_sprite(enemy, indicator) -> void:
	
	if active_target:
		if enemy == active_target:
			if not indicator.is_crosshair:
				indicator.set_crosshair()
		else:
			if not indicator.is_red_dot:
				indicator.set_red_dot()
	else:
		if not indicator.is_red_dot:
				indicator.set_red_dot()
		
func on_Enemy_died(object) -> void:
	
	enemies[object].queue_free()
	enemies.erase(object)
	enemies_dead.append(object)
	
func on_Player_global_values(g_position, g_rotation) -> void:
	
	player_global_position = g_position
	player_global_rotation = g_rotation
	
func on_Player_auto_gun_set_target(object) -> void:
	
	active_target = object

func on_Player_auto_gun_target_lost() -> void:
	
	active_target = null
