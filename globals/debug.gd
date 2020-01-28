extends Node

onready var debug_status = preload("res://debug/DebugStatus.tscn")
onready var debug_scene = preload("res://debug/DebugTool.tscn")
var debug
var status
var show_debug: bool = false

func _ready() -> void:
	
	debug = debug_scene.instance()
	status = debug_status.instance()
	var node = get_tree().root.get_children()[1]
	node.add_child(status)

func _input(event: InputEvent) -> void:
	
	if event is InputEventKey and event.is_action_pressed("debug"):		
		if not show_debug:
			var node = get_tree().root.get_children()[1]
			node.add_child(debug)
			status.debug_on()
			show_debug = true
		else:
			var node = get_tree().root.get_children()[1]
			node.remove_child(debug)
			status.debug_off()
			show_debug = false

func add(n_name, do_debug = true) -> void:
	
	debug.debug_node(n_name.to_upper(), do_debug)
			
func do(n_name, v_name, v_value) -> void:
	
	if show_debug:
		debug.debug_variable(n_name.to_upper(), v_name, v_value)
		
