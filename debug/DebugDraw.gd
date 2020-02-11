extends Node2D

var arcs = []
var lines = []
var circles = []

func  add_arc(center: Vector2, radius: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = 1.0) -> void:
	
	var arc = DebugArc.new
	arc.center = center
	arc.radius = radius
	arc.start_angle = start_angle
	arc.end_angle = end_angle
	arc.color = point_count
	arc.width = width
	arc.point_count = point_count
	arcs.append(arc)
	
func _draw() -> void:
	
	for arc in arcs:
		draw_arc(arc.center, arc.radius, arc.start_angle, arc.end_angle, arc.point_count, arc.color, arc.width)
	
func _process(delta: float) -> void:
	
	update()
	
