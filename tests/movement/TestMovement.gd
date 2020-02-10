extends Node2D

var target = preload("res://tests/movement/UnitTestTarget.tscn")
var real_target = null
var is_mouse_on_tool = false
onready var move_tool_margin: MarginContainer = $CanvasLayer/MovementTool
signal target_changed(target)

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.is_pressed() and not is_mouse_over_tool(event):
		if not real_target:		
			real_target = target.instance()
			real_target.global_position = event.position
			add_child(real_target)
			emit_signal("target_changed", real_target)
		else:
			real_target.global_position = event.position
			emit_signal("target_changed", real_target)

func is_mouse_over_tool(event: InputEvent) -> bool:
	
	var size = move_tool_margin.rect_size
	return event.position.x <= size.x and event.position.y <= size.y
