extends Position2D

export var bullet: PackedScene

var m_bullet_scale setget set_bullet_scale
var m_attack_groups setget set_attack_groups

func shoot() -> void:
	
	if(m_attack_groups == null):
		push_error("No attack group assigned to gun")
		
	var new_bullet = bullet.instance()
	var direction = Vector2(1, 0).rotated(global_rotation)
	new_bullet.set_attack_groups(m_attack_groups)
	new_bullet.shoot(global_position, direction)	
	new_bullet.global_scale = global_scale
	get_tree().root.add_child(new_bullet)

func set_attack_groups(attack_groups) -> void:

	m_attack_groups = attack_groups
	
func set_bullet_scale(bullet_scale) -> void:
	
	m_bullet_scale = bullet_scale