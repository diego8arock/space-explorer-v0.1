extends Node
class_name IStateMachine, "res://interfaces/state_machine.gd"

signal state_changed

onready var machine_owner = owner
var states_stack = []
var current_state = null
var states_map = {}

func _ready():
	
	init_state_machine()
	
func init_state_machine() -> void:
	
	var states = get_children()
	
	if states.size() == 0:
		push_warning("State machines as no states children")
	
	for state_node in get_children():
		state_node.connect("finished", self, "change_state")
	
	fill_states_map()
	#Initialize states_stack, current_state and call change_state in override
	#states_stack.push_front($States/FirstState)
	#current_state = states_stack[0]
	#_change_state("state_name")
	
func fill_states_map() -> void:
	
	push_error("fill_states_map function was not overriden")
	assert(false)

func change_state(state_name) -> void:
	
	push_warning("change_state function was not overriden")
	
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		var new_state = states_map[state_name]
		states_stack[0] = new_state

	current_state = states_stack[0]
	if state_name != "previous":
		# We don"t want to reinitialize the state if we"re going back to the previous state
		current_state.enter()
	emit_signal("state_changed", states_stack)
