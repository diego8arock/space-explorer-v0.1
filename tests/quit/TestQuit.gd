extends Control

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_TouchScreenButton_pressed() -> void:
	
	get_tree().quit()
