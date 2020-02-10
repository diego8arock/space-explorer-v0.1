extends HBoxContainer

var value = 100.0
signal value_changed(value)

func _ready() -> void:
	
	$Name.text = name
	$Value.text = str(value)

func _on_Increase_pressed() -> void:
	
	value += 1.0
	$Value.text = str(value)

func _on_Decrease_pressed() -> void:
	
	value -= 1.0
	$Value.text = str(value)

func _on_Value_text_entered(new_text: String) -> void:
	
	if new_text.is_valid_float() or new_text.is_valid_integer():
		value = float(new_text)
		$Value.text = str(value)
		emit_signal("value_changed", value)
	else:
		$Value.text = str(value)

func _on_Value_focus_exited() -> void:
	
	$Value.emit_signal("text_entered", $Value.text)
