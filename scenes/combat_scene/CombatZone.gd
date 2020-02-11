extends Node2D

var debug = false
var all_targets = []
var m_draw_radius

func _draw() -> void:
	
	if debug:
		if m_draw_radius:
			draw_arc(Vector2.ZERO, m_draw_radius, deg2rad(0), deg2rad(360), 50, Color(1,1,1))	
	
func create_targets(layers: int, radius: float) -> void:
	
	m_draw_radius = radius
	var angle_value = 90
	var radius_increment = radius / layers
	radius = radius_increment
	var number_of_targets = 4
	for i in range(layers):		
		var angle = 0
		for i in range(number_of_targets):
			var ttm = create_target_in_space()
			add_child(ttm)
			ttm.get_child(0).position.x += radius
			ttm.get_child(0).visible = false
			ttm.rotate(deg2rad(angle))
			all_targets.append(ttm.get_child(0).global_position) #we only need the final global_position
			ttm.queue_free() #prevent from creating nodes
			angle += angle_value
		angle_value /= 2
		number_of_targets *= 2
		radius += radius_increment
	
func create_target_in_space() -> Node2D:
	
	var base = Node2D.new()
	var target = Node2D.new()
	base.add_child(target)
	return base

func on_AttackShip_request_random_ttm(object) -> void:
	
	if all_targets.size() > 0:
		randomize()
		var index = randi() % all_targets.size() - 1
		object.set_random_ttm(all_targets[index])
