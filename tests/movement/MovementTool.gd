extends MarginContainer

signal option_changed(value)
signal speed_changed(value)
signal force_changed(value)
signal mass_changed(value)
signal rotation_changed(value)


func _ready() -> void:
	
	$VBoxContainer/OptionButton.add_item("ARRIVE",0)
	$VBoxContainer/OptionButton.add_item("PURSUIT",1)
	$VBoxContainer/OptionButton.add_item("FOLLOW",2)
	var option = $VBoxContainer/OptionButton.get_item_text(0)
	emit_signal("option_changed", option)	
	
	var children = get_children()
	

func _on_Speed_value_changed(value) -> void:
	
	emit_signal("speed_changed", value)

func _on_Force_value_changed(value) -> void:
	
	emit_signal("force_changed", value)

func _on_Mass_value_changed(value) -> void:
	
	emit_signal("mass_changed", value)

func _on_OptionButton_item_selected(id: int) -> void:
	
	var option = $VBoxContainer/OptionButton.get_item_text(id)
	emit_signal("option_changed", option)

func _on_Rotation_value_changed(value) -> void:
	
	emit_signal("rotation_changed", value)


