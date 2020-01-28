extends Sprite

#https://www.youtube.com/watch?v=uGyEP2LUFPg
onready var button = $JoystickButton
export var debug: bool = false
var radius = Vector2(50, 50)
var boundary = 50
var ongoing_drag = -1
var return_accel = 20.0
var threshold = 10

func _ready() -> void:
	
	Debug.add(name, debug)

func _process(delta: float) -> void:
	
	if ongoing_drag == -1:
		var pos_diff = (Vector2.ZERO - radius) - button.position
		button.position += pos_diff * return_accel * delta

func get_button_pos() -> Vector2:
	
	return button.position + radius

func _input(event: InputEvent) -> void:
	
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_center = (event.position - global_position).length()
		
		if event_dist_from_center <= boundary * button.global_scale.x or event.get_index() == ongoing_drag:	
			button.global_position = event.position - radius * button.global_scale
			
			if get_button_pos().length() > boundary:
				button.position = get_button_pos().normalized() * boundary - radius
				
			ongoing_drag = event.get_index()
		
		Events.emit_signal("joystick_moved", get_value())
			
	if event is InputEventScreenTouch and !event.is_pressed()  and event.get_index() == ongoing_drag:
		ongoing_drag = -1
		
	
		
func get_value() -> Vector2:
	
	if get_button_pos().length() > threshold:
		Debug.do(name, "joystick-value", get_button_pos().normalized())
		return get_button_pos().normalized()
	return Vector2.ZERO