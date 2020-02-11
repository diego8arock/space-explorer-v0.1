extends Area2D

onready var target_to_move = preload("res://tests/combat_zone/TargetToMove.tscn")
var targets_tm = []
onready var shape: CircleShape2D = $CollisionShape2D.shape

func _ready() -> void:
	
	create_targets(4)

func _draw() -> void:
	
	draw_arc(Vector2.ZERO, shape.radius, deg2rad(0), deg2rad(360), 50, Color(1,1,1))
	

func create_targets(layers) -> void:
	
	var angle_value = 90
	var radius_increment = shape.radius / layers
	var radius = radius_increment
	var number_of_targets = 4
	for i in range(layers):
		
		var angle = 0
		for i in range(number_of_targets):
			var ttm = target_to_move.instance()
			add_child(ttm)
			ttm.get_node("Sprite").position.x += radius
			ttm.get_node("Sprite").visible = false
			ttm.rotate(deg2rad(angle))
			targets_tm.append(ttm.get_node("Sprite"))
			angle += angle_value
		angle_value /= 2
		number_of_targets *= 2
		radius += radius_increment

func _on_AttackShip_request_random_ttm(object) -> void:
	
	if targets_tm.size() > 0:
		randomize()
		var index = randi() % targets_tm.size() - 1
		object.set_random_ttm(targets_tm[index])
	
