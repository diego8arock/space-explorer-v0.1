extends Control

onready var debug_variable_scene = preload("res://debug/DebugVariable.tscn")
var variables = {}
var nodes_do_debug = {}

func debug_node(n_name, do_debug = true) -> void:

	nodes_do_debug[n_name] = do_debug

func debug_variable(n_name, v_name, v_value) -> void:

	if not nodes_do_debug.has(n_name):
		return

	if nodes_do_debug.has(n_name) && not nodes_do_debug[n_name]:
		return

	var full_name = str(n_name) + "  " + str(v_name)
	if not variables.has(full_name):
		add_variable(full_name, v_value)
	else:
		update_variable(full_name, v_value)

func add_variable(v_name, v_value) -> void:

	var label = debug_variable_scene.instance()
	label.set_name(v_name)
	label.set_value(v_value)
	$VBoxContainer.add_child(label)
	variables[v_name] = label

func update_variable(v_name, v_value) -> void:

	var label = variables[str(v_name)]
	label.set_value(v_value)



