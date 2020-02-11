extends Node

onready var debug_status = preload("res://debug/DebugStatus.tscn")
onready var debug_scene = preload("res://debug/DebugTool.tscn")
var debug
var status
var show_debug_ui: bool = true
var node

func _ready() -> void:
	
	debug = debug_scene.instance()
	status = debug_status.instance()
	var children_count = get_tree().root.get_child_count()
	var children = get_tree().root.get_children()
	node = children[children_count - 1] #usually the main scene node
	insert_debug()
		
func insert_debug() -> void:
	
	if node.has_node("CanvasLayer"):
		node = node.get_node("CanvasLayer")
	if node.has_node("UI"):
		node = node.get_node("UI")
	node.add_child(status)
	if show_debug_ui:
		show_debug()
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventKey and event.is_action_pressed("debug"):		
		if not show_debug_ui:
			show_debug()
		else:
			hide_debug()
			
func show_debug() -> void:  
	
	node.add_child(debug)
	status.debug_on()
	show_debug_ui = true
	
func hide_debug() -> void:
	
	node.remove_child(debug)
	status.debug_off()
	show_debug_ui = false	

func add(n_name, do_debug = true) -> void:
	
	debug.debug_node(n_name.to_upper(), do_debug)
			
func do(n_name, v_name, v_value) -> void:
	
	if show_debug_ui:
		debug.debug_variable(n_name.to_upper(), v_name, v_value)
		
