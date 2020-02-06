extends Control

func debug_on() -> void:
	
	$MarginContainer/Label.text = "DEBUG ON"
	
func debug_off() -> void:
	
	$MarginContainer/Label.text = "DEBUG OFF"
